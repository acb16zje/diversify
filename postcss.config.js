const tailwindcss = require('tailwindcss')({ important: true });
const postCssImport = require('postcss-import');
const cssNano = require('cssnano');
const purgeCss = require('@fullhuman/postcss-purgecss')({
  content: [
    './app/**/*.haml',
    './app/helpers/**/*.rb',
    './app/**/*.js',
    './app/**/*.vue',
  ],
  defaultExtractor: (content) => content.match(/[\w-:/]+/g) || [],
  whitelist: [
    '::placeholder',
    'img',
    'image',
    'disabled',
    'is-expanded',
    'is-loading',
  ],
  whitelistPatternsChildren: [
    // action-text
    /trix/,

    // buefy
    /modal/, /navbar/, /dropdown/, /pagination/, /level/, /tabs/, /tooltip/,
    /progress/, /slider/, /has-icons/, /tag/,
  ],
});

module.exports = {
  plugins: [
    tailwindcss,
    postCssImport,
    purgeCss,
    cssNano,
  ],
};
