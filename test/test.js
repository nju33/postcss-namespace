import fs from 'fs';
import test from 'ava';
import postcss from 'postcss';
import namespace from '..';

const css = fs.readFileSync('../examples/sample.css', 'utf-8');
const expect = fs.readFileSync('./expect.css', 'utf-8');

function transform() {
  return new Promise(resolve => {
    postcss([namespace({token: '__'})])
      .process(css)
      .then(result => resolve(result.css));
  });
}

test('namespace', async t => {
  t.is(await transform(), expect);
});
