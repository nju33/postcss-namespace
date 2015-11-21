fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'

namespace = postcss.plugin 'postcss-namespace', (opts) ->
  if not opts?
    opts = {token: '-'}

  (css) ->
    namespaces = []

    css.walkAtRules 'namespace', (rule) ->
      namespace = rule.params
      line = rule.source.start.line
      if namespaces.length is 0
        namespaces.push {namespace, line , nextLine: null}
      else
        nextLine = rule.source.start.line
        namespaces[namespaces.length - 1].nextLine = nextLine
        namespaces.push {namespace, line, nextLine: null}
      rule.remove()

    if namespaces.length isnt 0
      target = namespaces.shift()

      css.walkRules (rule) ->
        currentLine = rule.source.start.line

        if target.nextLine? and target.nextLine < currentLine
          target = namespaces.shift()

        if target.line < currentLine
          selector = rule.selector
          re = /[^>]+/g
          result = ''
          handler = (m, idOrClass, name) ->
            if target.namespace
              idOrClass + target.namespace + opts.token + name
            else
              idOrClass + name

          while (matched = re.exec selector)?
            rToken = /&?\s*(\.|#)/
            if matched.index is 0 or matched[0][0] is '&'
              result += matched[0].replace rToken, (m, selectorToken) ->
                if target.namespace
                  selectorToken + target.namespace + opts.token
                else
                  selectorToken
            else
              result += '>' + matched[0]

          rule.selector =
            if result then result
            else selector.replace /(\.|#)/, (selectorToken) ->
              selectorToken + target.namespace + opts.token

module.exports = namespace
