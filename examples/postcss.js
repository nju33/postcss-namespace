const fs = require('fs');
const postcss = require('postcss');
const namespace = require('..');

const css = fs.readFileSync('./sample.css', 'utf-8');

postcss([namespace({token: '__'})])
  .process(css)
  .then(result => console.log(result.css));
