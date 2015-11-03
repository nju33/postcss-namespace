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
@namespace thing;
.box {
  width: 5em;
  height: 5em
}

.inner {
  width: 1em;
  mragin: 0 auto;
}

@namespace ;
.box {
  width: 3em;
  height: 3em;
}

.inner {
  width: .5em;
  mragin: 0 auto;
}

@namespace thing2;
.box {
  width: 8em;
  height: 8em;
}

.inner {
  width: 3em;
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
 *     height: 5em
 *   }
 *
 *   .thing__inner {
 *     width: 1em;
 *     mragin: 0 auto;
 *   }
 *   .box {
 *     width: 3em;
 *     height: 3em;
 *   }
 *
 *   .inner {
 *     width: .5em;
 *     mragin: 0 auto;
 *   }
 *   .thing2__box {
 *     width: 8em;
 *     height: 8em;
 *   }
 *
 *   .thing2__inner {
 *     width: 3em;
 *     mragin: 0 auto;
 *   }
 *
 */
```

## Options

- `token`  
  Token for consolidate(e.g.) `namespace({token: '__'})`  
  By default, it is `-`
