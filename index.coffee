fs            = require 'fs'
path          = require 'path'
CSON          = require 'cson'
postcss       = require 'postcss'

namespace = postcss.plugin 'postcss-namespace', (opts) ->
  if not opts?
    opts = {case: '-'}

  (css) ->
    namesapce = null

    css.walkAtRules 'namespace', (rule) ->
      namespace = rule.params
      rule.remove()

    if namespace?
      css.walkRules (rule) ->
        selector = rule.selector
        re = /^([#\.])([^\s\[]+)/g
        handler = (m, idOrClass, name) ->
          idOrClass + namespace + opts.case + name

        rule.selector = selector.replace re, handler

module.exports = namespace
