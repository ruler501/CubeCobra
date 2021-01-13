const  clientConfig = { ...require('./webpack.dev') };

delete clientConfig.externals;

module.exports = clientConfig;
