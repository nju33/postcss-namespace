# postcss-namespace

[![npm version](https://badge.fury.io/js/postcss-namespace.svg)](https://badge.fury.io/js/postcss-namespace)
[![Build Status](https://travis-ci.org/totora0155/postcss-namespace.svg?branch=master)](https://travis-ci.org/totora0155/postcss-namespace)
[![XO code style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)

<p><img width="20" src="https://camo.githubusercontent.com/2ec260a9d4d3dcc109be800af0b29a8471ad5967/687474703a2f2f706f73746373732e6769746875622e696f2f706f73746373732f6c6f676f2e737667"> [PostCSS](https://github.com/postcss/postcss) plugin that prefix a namespace to a selector</p>

---

## Install

```
npm i postcss-namespace
```

## Usage

Write `@prefix` atrule to your css file.
(e.g. input.css)
```css
.outside {}

@prefix block not(.not-target, /ignore/);

.box {}
.inner {}

/* comments */

.inner .exists {}
.inner .not-target {}
.inner .ignore-1 {}
.inner .exists,
.inner .ignore-2,
.inner .outside {}

@prefix ;

.box {}
.inner {}

@prefix block2;

.box {}
.inner {}
&:hover {}
[class*="box"] {}
[href^="https"][target="_blank"] {}

```

Use this plugin in PostCSS
(e.g.)
```javascript
const fs = require('fs');
const postcss = require('postcss');
const namespace = require('postcss-namespace');

const css = fs.readFileSync('./sample.css', 'utf-8');

postcss([namespace({token: '__'})])
  .process(css)
  .then(result => console.log(result.css));

```

Will get `output` like following CSS

```css
.outside {}

.block__box {}
.block__inner {}

/* comments */

.block__inner .block__exists {}
.block__inner .not-target {}
.block__inner .ignore-1 {}
.block__inner .block__exists,
.block__inner .ignore-2,
.block__inner .block__outside {}

.box {}
.inner {}

.block2__box {}
.block2__inner {}
&:hover {}
[class*="box"] {}
[href^="https"][target="_blank"] {}

```

## Options

- `token`  
  Token for consolidate(e.g.) `namespace({token: '__'})`  
  By default, it is `-`

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
cd examples && node postcss.js
```

## Change log

|version|log|
|:-:|:--|
|1.0.0|Rewrite with es2015 & Add not func in AtRule|
|0.2.5|Bug fix for `:nth*` selector & Revert v0.2.2 |
|0.2.4|Bug fix for pseudo selector|
|0.2.3|Bug fix (Tag not output after atrule)|
|0.2.2|Fix, occured error to [postcss-selector-not](https://github.com/postcss/postcss-selector-not) syntax|
|0.2.0|Change at-rule keyword to `@prefix` from `@namespace` [#1](https://github.com/totora0155/postcss-namespace/issues/1)|
