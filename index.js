// Generated by CoffeeScript 1.10.0
(function() {
  var namespace, postcss;

  postcss = require('postcss');

  namespace = postcss.plugin('postcss-namespace', function(opts) {
    var drop, getFirst, pick;
    if (opts == null) {
      opts = {
        token: '-'
      };
    }
    drop = function(selector) {
      return selector.replace(/^.*?(\.|#)/, "$1").replace(/\n/, '');
    };
    getFirst = function(selector) {
      return drop(selector).match(/^[^\s]+/)[0];
    };
    pick = function(str) {
      var selector;
      selector = (function() {
        var result;
        result = '';
        result = str.trim().replace(/^[^.#]*/, '');
        result = result.replace(/(\.|\(|\))/g, "\\$1");
        result = result.replace(/:.*$/, '');
        if (result[result.length - 1] === ',') {
          result += '?';
        }
        return result;
      })();
      return selector;
    };
    return function(css, result) {
      var atNamespace, name1, namespaceGroup;
      atNamespace = (function() {
        var current, data, get, next, reset;
        current = 0;
        data = [];
        reset = function() {
          current = 0;
          return this;
        };
        next = function() {
          current++;
          return this;
        };
        get = function() {
          var target;
          target = data[current];
          if (current != null) {
            next = data[current + 1];
            return {
              name: target.name,
              line: target.line,
              nextLine: next != null ? next.line : void 0
            };
          } else {
            return null;
          }
        };
        return {
          reset: reset,
          next: next,
          get: get,
          data: data
        };
      })();
      namespaceGroup = {};
      css.walkAtRules(/namespace|prefix/, function(rule) {
        var line, name;
        if (rule.name === 'namespace') {
          result.warn('@namespace is deprecated! please using @prefix at-rule.', {
            node: rule
          });
          return rule;
        }
        name = rule.params;
        line = rule.source.start.line;
        atNamespace.data.push({
          name: name,
          line: line
        });
        return rule.remove();
      });
      if (atNamespace.data.length === 0) {
        return;
      }
      namespace = atNamespace.get();
      namespaceGroup[name1 = namespace.name] || (namespaceGroup[name1] = []);
      css.walkRules(function(rule) {
        var currentLine, first, i, len, name2, selector, selectors;
        currentLine = rule.source.start.line;
        if (currentLine < namespace.line) {
          return rule;
        }
        if ((namespace.nextLine != null) && currentLine > namespace.nextLine) {
          while ((namespace != null) && currentLine > namespace.nextLine) {
            namespace = atNamespace.next().get();
            namespaceGroup[name2 = namespace.name] || (namespaceGroup[name2] = []);
          }
        }
        if (currentLine > namespace.line) {
          selectors = rule.selector.split(/,(?!.*?\))/);
          for (i = 0, len = selectors.length; i < len; i++) {
            selector = selectors[i];
            if (!/\s*(?:\.|#)/.test(selector)) {
              return rule;
            }
            first = getFirst(selector);
            namespaceGroup[namespace.name];
            if (!new RegExp(first).test(namespaceGroup[namespace.name].join(','))) {
              namespaceGroup[namespace.name].push(first);
            }
          }
        }
      });
      namespace = atNamespace.reset().get();
      return css.walkRules(function(rule) {
        var currentLine, matched, rSelector, re;
        currentLine = rule.source.start.line;
        if (currentLine < namespace.line) {
          return rule;
        }
        if (!/^\s*(?:\.|#)/.test(rule.selector)) {
          return rule;
        }
        result = '';
        if ((namespace.nextLine != null) && currentLine > namespace.nextLine) {
          while ((namespace != null) && currentLine > namespace.nextLine) {
            namespace = atNamespace.next().get();
          }
        }
        if (currentLine > namespace.line) {
          re = /\s*(?:>|\+|~)?\s*(\.|#)[^)]+?[^\s]+/g;
          while ((matched = re.exec(rule.selector)) != null) {
            matched = matched[0];
            rSelector = new RegExp(pick(matched));
            if (rSelector.test(namespaceGroup[namespace.name].join(','))) {
              if (namespace.name) {
                result += matched.replace(/(\.|#)/, function(selectorToken) {
                  return selectorToken + namespace.name + opts.token;
                });
              } else {
                result += matched;
              }
            } else {
              result += matched;
            }
          }
        }
        rule.selector = result;
        return rule;
      });
    };
  });

  module.exports = namespace;

}).call(this);
