const tailwindcss = require('tailwindcss');
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
    'is-expanded',
    'disabled',
  ],
  whitelistPatternsChildren: [
    /modal/, /navbar/, /dropdown/, /pagination/, /level/, /trix/, /tabs/,
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
