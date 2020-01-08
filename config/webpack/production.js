process.env.NODE_ENV = process.env.NODE_ENV || 'production';

const config = require('./environment').toWebpackConfig();

config.optimization.minimizer[0].options.extractComments = false;

module.exports = config;
