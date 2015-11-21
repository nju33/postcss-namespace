// Generated by CoffeeScript 1.10.0
(function() {
  var CSON, fs, namespace, path, postcss;

  fs = require('fs');

  path = require('path');

  CSON = require('cson');

  postcss = require('postcss');

  namespace = postcss.plugin('postcss-namespace', function(opts) {
    var prefix, rToken;
    if (opts == null) {
      opts = {
        token: '-'
      };
    }
    rToken = /&?\s*(\.|#)/;
    prefix = function(selector, namespace) {
      if (namespace) {
        return selector.replace(rToken, function(m, selectorToken) {
          return selectorToken + namespace + opts.token;
        });
      } else {
        return selectorToken;
      }
    };
    return function(css) {
      var namespaces, target;
      namespaces = [];
      css.walkAtRules('namespace', function(rule) {
        var line, nextLine;
        namespace = rule.params;
        line = rule.source.start.line;
        if (namespaces.length === 0) {
          namespaces.push({
            namespace: namespace,
            line: line,
            nextLine: null
          });
        } else {
          nextLine = rule.source.start.line;
          namespaces[namespaces.length - 1].nextLine = nextLine;
          namespaces.push({
            namespace: namespace,
            line: line,
            nextLine: null
          });
        }
        return rule.remove();
      });
      if (namespaces.length !== 0) {
        target = namespaces.shift();
        return css.walkRules(function(rule) {
          var currentLine, handler, matched, re, result, selector;
          currentLine = rule.source.start.line;
          if ((target.nextLine != null) && target.nextLine < currentLine) {
            target = namespaces.shift();
          }
          if (target.line < currentLine) {
            selector = rule.selector;
            re = /[^>]+/g;
            result = '';
            handler = function(m, idOrClass, name) {
              if (target.namespace) {
                return idOrClass + target.namespace + opts.token + name;
              } else {
                return idOrClass + name;
              }
            };
            if (/^&\s*(?:\.|#)/.test(selector)) {
              return;
            }
            while ((matched = re.exec(selector)) != null) {
              if (matched.index !== 0) {
                if (matched[0][0] === '&') {
                  result += prefix(matched[0], target.namespace);
                } else {
                  result += '>' + matched[0];
                }
              } else {
                if (!/^\s*&/.test(matched[0][0])) {
                  if (target.namespace) {
                    result += prefix(matched[0], target.namespace);
                  } else {
                    result += matched[0];
                  }
                }
              }
            }
            return rule.selector = result;
          }
        });
      }
    };
  });

  module.exports = namespace;

}).call(this);
