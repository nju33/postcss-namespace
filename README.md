# postcss-namespace

[PostCSS](https://github.com/postcss/postcss) plugin that prefix a namespace to a selector

## Install

```
npm i -D postcss-namespace
npm i -D postcss # if still
```

## Usage

Write `@namespace` atrule to your css.
(e.g. input.css)
```css
.outside {}

@namespace block;
.box {}

.inner {}

.inner .inside {}
.inner .outside {}

.inside {}


@namespace ;
.box {}

.inner {}

@namespace block2;
.box {}

.inner {}

```

Use postcss-namespace plugin in PostCSS
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
/* output:
 *
 *   .outside {}
 *   .block__box {}
 *
 *   .block__inner {}
 *
 *   .block__inner .block__inside {}
 *   .block__inner .outside {}
 *
 *   .block__inside {}
 *   .box {}
 *
 *   .inner {}
 *   .block2__box {}
 *
 *   .block2__inner {}
 *
 */
```

## Options

- `token`  
  Token for consolidate(e.g.) `namespace({token: '__'})`  
  By default, it is `-`
