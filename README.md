# postcss-namespace

[![npm version](https://badge.fury.io/js/postcss-namespace.svg)](https://badge.fury.io/js/postcss-namespace)
[![Build Status](https://travis-ci.org/totora0155/postcss-namespace.svg?branch=master)](https://travis-ci.org/totora0155/postcss-namespace)
[![XO code style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)

<p><img width="20" src="https://camo.githubusercontent.com/2ec260a9d4d3dcc109be800af0b29a8471ad5967/687474703a2f2f706f73746373732e6769746875622e696f2f706f73746373732f6c6f676f2e737667"> <a href="https://github.com/postcss/postcss">PostCSS</a> plugin that prefix a namespace to a selector</p>

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

.inner .target {}
.inner .not-target {}
.inner .ignore-1 {}
.inner .ignore-2,
.inner .target {}

@prefix ;

.box {}

@prefix block2;

.box {}
&:hover {}
[href^="https"][target="_blank"] {}

@media screen and (min-width: 768px) {
  #media {}
  #media #inner,
  .media .inner.box {}
}

```

Use this plugin in PostCSS
(e.g.)
```javascript
const fs = require('fs');
const postcss = require('postcss');
const namespace = require('postcss-namespace');

const css = fs.readFileSync('./sample.css', 'utf-8');

// or postcss([namespace.bem])
postcss([namespace({token: '__'})])
  .process(css)
  .then(result => console.log(result.css));

```

Will get `output` like following CSS

```css
.outside {}

.block__box {}

.block__inner .block__target {}
.block__inner .not-target {}
.block__inner .ignore-1 {}
.block__inner .ignore-2,
.block__inner .block__target {}

.box {}

.block2__box {}
&:hover {}
[href^="https"][target="_blank"] {}

@media screen and (min-width: 768px) {
  #block2__media {}
  #block2__media #block2__inner,
  .block2__media .block2__inner.block2__box {}
}

```

## AtRule Function

- `not` (string|regexp)...  
Specify selector or pattern which Don't want a prefix

## Plugin Function

- `namespace.bem`  
  Same as `namespace({token: '__'})`

## Options

- `token`  
  Token for consolidate(e.g.) `namespace({token: '__'})`  
  `-` by default

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
|1.1.0|Add `bem` function. (Alias `{token: '__'}`)|
|1.0.1|Fix `node.nodes`|
|1.0.0|Rewrite with es2015 & Add not func in AtRule|
|0.2.5|Bug fix for `:nth*` selector & Revert v0.2.2 |
|0.2.4|Bug fix for pseudo selector|
|0.2.3|Bug fix (Tag not output after atrule)|
|0.2.2|Fix, occured error to [postcss-selector-not](https://github.com/postcss/postcss-selector-not) syntax|
|0.2.0|Change at-rule keyword to `@prefix` from `@namespace` [#1](https://github.com/totora0155/postcss-namespace/issues/1)|
