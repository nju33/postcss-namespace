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
    atNamespace = do ->
      current = 0
      data = []
      reset = ->
        current = 0
        return @
      next = ->
        current++
        return @
      get = ->
        target = data[current]
        if current?
          next = data[current+1]

          name: target.name
          line: target.line
          nextLine: next?.line
        else
          null

      {reset, next, get, data}

    namespaceGroup = {}

    css.walkAtRules 'namespace', (rule) ->
      name = rule.params
      line = rule.source.start.line

      atNamespace.data.push {name, line}
      rule.remove()

    if atNamespace.data.length is 0
      return


    namespace = atNamespace.get()
    namespaceGroup[namespace.name] or= []
    css.walkRules (rule) ->
      currentLine = rule.source.start.line
      return rule if currentLine < namespace.line

      if namespace.nextLine? and currentLine > namespace.nextLine
        while namespace? and currentLine > namespace.nextLine
          namespace = atNamespace.next().get()
          namespaceGroup[namespace.name] or= []

      if currentLine > namespace.line
        if not /\s*(?:\.|#)/.test rule.selector
          return rule

        first = rule.selector.split(/\s/)[0]
        namespaceGroup[namespace.name]
        if not new RegExp(first).test namespaceGroup[namespace.name].join(',')
          namespaceGroup[namespace.name].push first


    namespace = atNamespace.reset().get()
    css.walkRules (rule) ->
      currentLine = rule.source.start.line
      if currentLine < namespace.line
        return rule

      result = ''

      if namespace.nextLine? and currentLine > namespace.nextLine
        while namespace? and currentLine > namespace.nextLine
          namespace = atNamespace.next().get()

      if currentLine > namespace.line
        re = /\s*(?:>|\+|~)?\s*(\.|#)[^\s]+/g

        while (matched = re.exec rule.selector)?
          [matched] = matched
          [selector] = matched.match /[^\s]+$/

          if new RegExp(selector).test namespaceGroup[namespace.name].join(',')
            if namespace.name
              result += matched.replace /(\.|#)/, (selectorToken) ->
                  selectorToken + namespace.name + opts.token
            else
              result += matched
          else
            result += matched

      rule.selector = result
      rule


module.exports = namespace
