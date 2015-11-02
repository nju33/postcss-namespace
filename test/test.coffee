fs           = require 'fs'
path         = require 'path'
CSON         = require 'cson'
chai         = require 'chai'
expect       = chai.expect
postcss      = require 'postcss'

namespace = require '..'

set = (dir) ->
  stylePath = path.join 'test/cases/', dir, 'thing.css'
  answerPath = path.join 'test/cases/', dir, 'answer.css'

  style: fs.readFileSync stylePath, 'utf-8'
  answer: fs.readFileSync answerPath, 'utf-8'

describe 'postcss-cson-cssvars', ->
  it 'expect concat chain', ->
    {style, answer} = set 'chain'

    result = postcss([namespace]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat scake', ->
    {style, answer} = set 'snake'

    result = postcss([namespace {case: '_'}]).process(style)
    expect(result.css).to.equal(answer)

  it 'expect concat bem', ->
    {style, answer} = set 'bem'

    result = postcss([namespace {case: '__'}]).process(style)
    expect(result.css).to.equal(answer)
