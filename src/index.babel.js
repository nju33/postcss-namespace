import postcss from 'postcss';
import _ from 'lodash';

const defaultOpts = {
  token: ' '
};

export default postcss.plugin('postcss-namespace', (opts = {}) => {
  opts = Object.assign({}, defaultOpts, opts);

  return css => {
    css.walkAtRules(/namespace/, rule => {
      const prefix = rule.params.match(/^[^\s]*/)[0];
      const ignored = (params => {
        const matches = params.match(/not\((.+)\)/);
        if (!matches) {
          return [];
        }

        const ignored = _.compact(matches[1].split(/\s*,\s*/));
        return _.map(ignored, target => {
          const matches = target.match(/\/(.+)\//);
          if (!matches) {
            return target;
          }
          return new RegExp(_.escapeRegExp(matches[1]));
        });
      })(rule.params);


      process(prefix, rule, ignored);
      rule.remove();
    });
  };

  function process(prefix, target, ignored) {
    if (!prefix) {
      return;
    }

    while ((target = target.next())) {
      if (isPrefixAtRule(target)) {
        break;
      }

      if (target.constructor.name === 'AtRule') {
        if (typeof target.nodes !== 'undefined' && target.nodes.length) {
          process(prefix, wrapNodes(target.nodes), ignored);
        }
      }

      if (target.constructor.name !== 'Rule') {
        continue;
      }

      const re = /[#.\[\&].+/g;
      target.selector = target.selector.replace(re, selector => {
        return `.${prefix}${opts.token}${selector}`;
      });
    }

    function isPrefixAtRule(target) {
      return Boolean(target.constructor.name === 'AtRule' &&
                     target.name === 'prefix');
    }

    function isIgnored(selector) {
      return _.some(_.map(ignored, target => {
        if (target.constructor.name === 'String') {
          return selector === target;
        } else if (target.constructor.name === 'RegExp') {
          return target.test(selector);
        }
      }));
    }

    function wrapNodes(nodes) {
      return {
        next() {
          return nodes[0];
        }
      };
    }
  }
});
