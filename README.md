# postcss-class-namespace

[![npm version](https://badge.fury.io/js/postcss-class-namespace.svg)](https://badge.fury.io/js/postcss-class-namespace)

<p><img width="20" src="https://camo.githubusercontent.com/2ec260a9d4d3dcc109be800af0b29a8471ad5967/687474703a2f2f706f73746373732e6769746875622e696f2f706f73746373732f6c6f676f2e737667"> <a href="https://github.com/postcss/postcss">PostCSS</a> plugin that prefix a namespace to a selector</p>

---

## Install

```
npm i postcss-class-namespace
```

## Usage

Write `@namespace` atrule to your css file.
(e.g. input.css)
```css
.outside {}

@namespace block;

.box {}

.inner .target {}
.inner .not-target {}
.inner .ignore-1 {}
.inner .ignore-2,
.inner .target {}

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
const namespace = require('postcss-class-namespace');

const css = fs.readFileSync('./sample.css', 'utf-8');

// or postcss([namespace.bem])
postcss([namespace({token: '__'})])
  .process(css)
  .then(result => console.log(result.css));

```

Will get `output` like following CSS

```css
.outside {}

.block .box {}

.block .inner .target {}
.block .inner .not-target {}
.block .inner .ignore-1 {}
.block .inner .ignore-2,
.block .inner .target {}

.block &:hover {}
.block [href^="https"][target="_blank"] {}

@media screen and (min-width: 768px) {
  .block #media {}
  .block #media #inner,
  .block .media .inner.box {}
}
```
