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
          re = /^([#\.])([^\s\[]+)/g
          handler = (m, idOrClass, name) ->
            if target.namespace
              idOrClass + target.namespace + opts.token + name
            else
              idOrClass + name

          rule.selector = selector.replace re, handler

module.exports = namespace
