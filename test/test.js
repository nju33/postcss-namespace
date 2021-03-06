import fs from 'fs';
import test from 'ava';
import postcss from 'postcss';
import namespace from '..';

const css = fs.readFileSync('../examples/sample.css', 'utf-8');
const expect = fs.readFileSync('./expect.css', 'utf-8');

function transform(plugin) {
  return new Promise(resolve => {
    postcss([plugin])
      .process(css)
      .then(result => resolve(result.css));
  });
}

test('namespace token', async t => {
  t.is(await transform(namespace({token: '__'})), expect);
});

test('namespace bem', async t => {
  t.is(await transform(namespace.bem), expect);
});
