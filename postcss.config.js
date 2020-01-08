const environment = {
  plugins: [
    require('postcss-import'),
    require('cssnano'),
    require('@fullhuman/postcss-purgecss')({
      content: [
        './app/**/*.haml',
        './app/helpers/**/*.rb',
        './app/**/*.js',
        './app/**/*.vue',
      ],
      defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
      whitelist: ['img', 'has-addons', 'is-expanded'],
      whitelistPatterns: [/mdi/],
      whitelistPatternsChildren: [
        /modal/, /dropdown/, /pagination/, /level/, /trix/,
      ],
    }),
  ],
};

module.exports = environment;
