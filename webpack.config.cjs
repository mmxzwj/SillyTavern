const process = require('process');
const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');

/** @type {import('webpack').Configuration} */
const publicLibConfig = {
    mode: process.env.NODE_ENV === 'production' ? 'production' : 'development',
    entry: './public/lib.js',
    cache: {
        type: 'filesystem',
        cacheDirectory: path.resolve(process.cwd(), 'dist/webpack'),
        store: 'pack',
        compression: 'gzip',
    },
    devtool: false,
    watch: false,
    module: {},
    stats: {
        preset: 'minimal',
        assets: false,
        modules: false,
        colors: true,
        timings: true,
    },
    experiments: {
        outputModule: true,
    },
    performance: {
        hints: false,
    },
    optimization: {
        minimize: process.env.NODE_ENV === 'production',
        minimizer: [new TerserPlugin()],
        splitChunks: {
            chunks: 'async',
            minSize: 20000,
            minChunks: 1,
            maxAsyncRequests: 30,
            maxInitialRequests: 30,
            enforceSizeThreshold: 50000,
            cacheGroups: {
                defaultVendors: {
                    test: /[\\/]node_modules[\\/]/,
                    priority: -10,
                    reuseExistingChunk: true,
                },
                default: {
                    minChunks: 2,
                    priority: -20,
                    reuseExistingChunk: true,
                },
            },
        },
    },
    output: {
        path: path.resolve(process.cwd(), 'dist'),
        filename: 'lib.js',
        libraryTarget: 'module',
        chunkFilename: '[name].[contenthash].js',
    },
};

module.exports = publicLibConfig; 