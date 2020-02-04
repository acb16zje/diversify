const postCssImport = require('postcss-import');
const cssNano = require('cssnano');
const purgeCss = require('@fullhuman/postcss-purgecss')({
  content: [
    './app/**/*.haml',
    './app/helpers/**/*.rb',
    './app/**/*.js',
    './app/**/*.vue',
  ],
  defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
  whitelist: ['::placeholder', 'disabled', 'img', 'has-addons', 'is-expanded'],
  whitelistPatternsChildren: [
    /modal/, /dropdown/, /pagination/, /level/, /trix/,
  ],
});

module.exports = {
  plugins: [
    postCssImport,
    cssNano,
    purgeCss,
  ],
};
