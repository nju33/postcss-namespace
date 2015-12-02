const fs = require('fs'),
      postcss = require('postcss'),
      namespace = require('..');

const before = fs.readFileSync('example/index.css', 'utf-8'),
      after = postcss([namespace({token: '__'})]).process(before).css;

console.log(after);
