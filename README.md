# postcss-namespace

[PostCSS](https://github.com/postcss/postcss) plugin that prefix a namespace to a selector

## Install

```
npm i -D postcss-namespace
npm i -D postcss # if still
```

## Usage

Add `@namespace` atrule
(e.g. input.css)
```css
@namespace thing;
.box {
  width: 5em;
  height: 5em
}

.inner {
  width: 1em;
  mragin: 0 auto;
}

```

Use postcss-namespace plugin in PostCSS
(e.g.)
```javascript
var fs = require('fs');
var postcss = require('postcss');
var namespace = require('postcss-namespace');
var css = fs.readFileSync('input.css', 'utf8');

var output = postcss()
  .use(namespace({case: '__'}))
  .process(css)
  .css;

console.log(output);
/* output:
 *
 *   .thing__box {
 *     width: 5em;
 *     height: 5em;
 *   }
 *
 *   .thing__inner {
 *     width: 1em;
 *     margin: 0 auto;
 *   }
 *
 */
```

## Options

- `case`  
  Token for consolidate(e.g.) `namespace({case: '__'})`  
  By default, it is `-`
