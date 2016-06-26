const plugin = require('./build').default;

plugin.bem = plugin({token: '__'});
module.exports = plugin;
