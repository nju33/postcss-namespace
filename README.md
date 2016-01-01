# postcss-namespace

[![npm version](https://badge.fury.io/js/postcss-namespace.svg)](https://badge.fury.io/js/postcss-namespace)
[![Build Status](https://travis-ci.org/totora0155/postcss-namespace.svg?branch=master)](https://travis-ci.org/totora0155/postcss-namespace)

[PostCSS](https://github.com/postcss/postcss) plugin that prefix a namespace to a selector

## Install

```
npm i postcss-namespace

# if still
npm i postcss
```

## Usage

Write `@prefix` atrule to your css file.
(e.g. input.css)
```css
.outside {}

@prefix block;

.box {}
.inner {}

.inner .exists {}
.inner .new {}
.inner .exists,
.inner .outside {}

.exists {}

@prefix ;

.box {}
.inner {}

@prefix block2;

.box {}
[class*="box"] {}
.inner {}

```

Use this plugin in PostCSS
(e.g.)
```javascript
var fs = require('fs');
var postcss = require('postcss');
var namespace = require('postcss-namespace');
var css = fs.readFileSync('input.css', 'utf8');

var output = postcss()
  .use(namespace({token: '__'}))
  .process(css)
  .css;

console.log(output);
```

Will get `output` like following CSS

```css
.outside {}

.block__box {}
.block__inner {}

.block__inner .block__exists {}
.block__inner .new {}
.block__inner .block__exists,
.block__inner .outside {}

.block__exists {}

.box {}
.inner {}

.block2__box {}
[class*="box"] {}
.block2__inner {}
```

## Options

- `token`  
  Token for consolidate(e.g.) `namespace({token: '__'})`  
  By default, it is `-`

## Tips

### With [postcss-selector-not](https://github.com/postcss/postcss-selector-not)

Process the postcss-selector-not before the postcss-namespace.

```js
postcss(
  [
    require('postcss-selector-not'),
    require('postcss-namespace')(...)
  ]
)
```

## Run to example

**1** Close this

```
git clone git@github.com:totora0155/postcss-namespace.git
```

**2** Change directory
```
cd postcss-namespace
```

**3** Install modules
```
npm install
```

**4** Run to script
```
npm run example
```

## Change log

|version|log|
|:-:|:--|
|0.2.5|Bug fix for `:nth*` selector & Revert v0.2.2 |
|0.2.4|Bug fix for pseudo selector|
|0.2.3|Bug fix (Tag not output after atrule)|
|0.2.2|Fix, occured error to [postcss-selector-not](https://github.com/postcss/postcss-selector-not) syntax|
|0.2.0|Change at-rule keyword to `@prefix` from `@namespace` [#1](https://github.com/totora0155/postcss-namespace/issues/1)|
