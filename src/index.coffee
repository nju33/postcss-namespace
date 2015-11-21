fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'

namespace = postcss.plugin 'postcss-namespace', (opts) ->
  if not opts?
    opts = {token: '-'}
  rToken = /&?\s*(\.|#)/

  prefix = (selector, namespace) ->
    if namespace
      selector.replace rToken, (m, selectorToken) ->
        selectorToken + namespace + opts.token
    else
      selectorToken

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

          if /^&\s*(?:\.|#)/.test  selector
            return

          while (matched = re.exec selector)?
            if matched.index isnt 0
              if matched[0][0] is '&'
                result += prefix matched[0], target.namespace
              else
                result += '>' + matched[0]
            else
              if not /^\s*&/.test matched[0][0]
                if target.namespace
                  result += prefix matched[0], target.namespace
                else
                  result += matched[0]

          rule.selector = result

module.exports = namespace
