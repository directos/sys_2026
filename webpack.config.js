const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');
const Workbox = require('workbox-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
const CompressionPlugin = require('compression-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const HtmlMinimizerPlugin = require("html-minimizer-webpack-plugin");

module.exports = {
    //stats: 'detailed', //'verbose', // 'errors-only', 
    entry: {
        'app': './src/frontend/index.js',                           // Login
        'movil/app-movil': './src/frontend/movil/index.js',         // Agendas móviles
        'desktop/app-desktop': './src/frontend/desktop/index.js',   // Sys de escritorio
        'desktop/app-lite': './src/frontend/lite/index.lite.js',    // Versión mini
        'board/app-board': './src/frontend/board/index.js',         // Para gerencia: charts y stats
    },
    output: {
        // eslint-disable-next-line no-undef
        path: path.join(__dirname, '/build'),
        filename: '[name].[chunkhash].js', // '[name].js',
        clean: true
    },
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin(),
            new CssMinimizerPlugin(),
            new HtmlMinimizerPlugin(),
        ],
        splitChunks: {
            chunks: 'all',
        },
        runtimeChunk: {
            name: 'js/runtime'
        }
    },
    module: {
        rules: [
            {
                test: /\.css$/i,    //  test: /.s?css$/
                use: [MiniCssExtractPlugin.loader, 'css-loader'],   //use: ['style-loader', 'css-loader'],
            }
        ]
    },
    plugins: [
        new CopyPlugin({
            patterns: [
                { from: './src/backend', to: './backend', globOptions: { dot: true, ignore: ['**/lib/**', '**/dev/**', '**/padron/**'] } },
                { from: './src/manifest.json', to: './' },
                { from: './src/frontend/assets', to: './assets', globOptions: { dot: true, ignore: ['**/img/**'] } },
                { from: './src/frontend/assets/img/logo_print_min.jpg', to: './assets/img' },
                { from: './src/frontend/templates', to: './templates' },
                { from: './src/frontend/desktop/pages', to: './desktop' },
                { from: './src/frontend/movil/pages', to: './movil' },
            ],
        }),
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: './src/frontend/index.html',
            chunks: ['app'],
            hash: false,            
            minify: {
                removeAttributeQuotes: true,
                collapseWhitespace: true,
                removeComments: true,
            },
        }),
        new HtmlWebpackPlugin({
            filename: 'movil/index.html',
            template: './src/frontend/movil/index.html',
            chunks: ['movil/app-movil'],
            hash: false,
            minify: {
                removeAttributeQuotes: true,
                collapseWhitespace: true,
                removeComments: true,
            },            
        }),
        new HtmlWebpackPlugin({
            filename: 'desktop/index.html',
            template: './src/frontend/desktop/index.html',
            chunks: ['desktop/app-desktop'],
            hash: false,
            minify: {
                removeAttributeQuotes: true,
                collapseWhitespace: true,
                removeComments: true,
            },            
        }),
        new HtmlWebpackPlugin({
            filename: 'desktop/index.lite.html',
            template: './src/frontend/lite/index.lite.html',
            chunks: ['desktop/app-lite'],
            hash: false,
            minify: {
                removeAttributeQuotes: true,
                collapseWhitespace: true,
                removeComments: true,
            },            
        }),
        new HtmlWebpackPlugin({
            template: './src/frontend/board/index.html',
            filename: 'board/index.html',
            chunks: ['board/app-board'],
            hash: false,
            minify: {
                removeAttributeQuotes: true,
                collapseWhitespace: true,
                removeComments: true,
            },
        }),
        /*new Workbox.GenerateSW({
            clientsClaim: false,
            skipWaiting: false,           
            exclude: [/\.(?:ini|php|py|gz|htaccess)$/], // excluimos archivos ini php y python del precaching.
        }),*/
        new Workbox.InjectManifest({
            swSrc: "./src/src-service-worker.js",
            swDest: "service-worker.js",
            exclude: [/\.(?:ini|php|py|gz|htaccess|txt)$/],
        }),
        new BundleAnalyzerPlugin({ analyzerMode: 'server', generateStatsFile: true }), // server, static, json, disabled
        new MiniCssExtractPlugin(),
        new CompressionPlugin({
            filename: '[path][name].gz[query]',
            algorithm: 'gzip',
            //test: /\.js$|\.css$|\.html$|\.eot?.+$|\.ttf?.+$|\.woff?.+$|\.svg?.+$/,
            threshold: 10240,
            minRatio: 0.8,
            exclude: /\/lib/,
        })
    ], performance: {
        maxEntrypointSize: 960000,
        maxAssetSize: 960000
    },
}