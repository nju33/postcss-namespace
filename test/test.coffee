fs           = require 'fs'
path         = require 'path'
chai         = require 'chai'
expect       = chai.expect
postcss      = require 'postcss'

namespace = require '..'

set = (dir) ->
  stylePath = path.join 'test/cases/', dir, 'thing.css'
  answerPath = path.join 'test/cases/', dir, 'answer.css'

  style: fs.readFileSync stylePath, 'utf-8'
  answer: fs.readFileSync answerPath, 'utf-8'

describe 'postcss-namespace', ->
  it 'expect concat chain token', ->
    {style, answer} = set 'chain'

    result = postcss([namespace]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat scake token', ->
    {style, answer} = set 'snake'

    result = postcss([namespace {token: '_'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat bem token', ->
    {style, answer} = set 'bem'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat when multi namespace', ->
    {style, answer} = set 'multi-namespace'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat when empty namespace', ->
    {style, answer} = set 'empty-namespace'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect before first namespace', ->
    {style, answer} = set 'before-first-namespace'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it.skip 'expect before first namespace', ->
    {style, answer} = set 'nest-selector'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect before first namespace', ->
    {style, answer} = set 'nest-selector2'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it.skip 'expect ignore pattern', ->
    {style, answer} = set 'ignore-pattern'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect multi selector', ->
    {style, answer} = set 'multi-selector'

    result = postcss([namespace {token: '__'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect [square-brachets]', ->
    {style, answer} = set 'square-brachets'

    {css} = postcss([namespace {token: '__'}]).process(style)
    expect(css).to.equal(answer)

  it 'postcss-selector-not syntax', ->
    {style, answer} = set 'with/postcss-selector-not'

    {css} = postcss([namespace {token: '__'}]).process(style)
    expect(css).to.equal(answer)
