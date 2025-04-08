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
const { VueLoaderPlugin } = require('vue-loader'); // Importa el plugin de Vue
const webpack = require('webpack');

const isProduction = process.env.NODE_ENV === 'production';

module.exports = {
    //stats: 'detailed', //'verbose', // 'errors-only', 
    entry: {
        'app': './src/frontend/main.js',                            // Login
        'movil/app-movil': './src/frontend/movil/index.js',         // Agendas móviles
        'desktop/app-desktop': './src/frontend/desktop/index.js',   // Sys de escritorio
        'desktop/app-lite': './src/frontend/lite/index.lite.js',    // Versión mini
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
                test: /\.vue$/, // Soporte para archivos .vue
                loader: 'vue-loader',
            },
            {
                test: /\.css$/i,    // Soporte para archivos CSS
                use: [MiniCssExtractPlugin.loader, 'css-loader'],
            },
            {
                test: /\.(png|jpe?g|gif|svg|webp)$/i,
                loader: 'file-loader',
                options: {
                    name: 'assets/img/[name].[ext]',
                },
            }
        ]
    },
    resolve: {
        alias: {
            vue$: 'vue/dist/vue.esm-bundler.js', // Asegura que Vue use el compilador de plantillas
            '@': path.resolve(__dirname, 'src/frontend'), // Alias para la carpeta src/frontend
            '@backend': path.resolve(__dirname, 'src/backend'), // Alias para la carpeta src/backend
        },
        extensions: ['.*', '.js', '.vue', '.json'], // Extensiones que Webpack resolverá automáticamente
    },
    plugins: [
        new VueLoaderPlugin(), // Plugin necesario para procesar archivos .vue
        new CopyPlugin({
            patterns: [
                { from: './src/backend', to: './backend', globOptions: { dot: true, ignore: ['**/setup/**', '**/dev/**', '**/padron/**'] } },
                { from: './src/frontend/manifest.json', to: './' },
                { from: './src/frontend/assets', to: './assets', globOptions: { dot: true, ignore: ['**/_img/**'] } },
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
        ...(isProduction ? [
            new Workbox.InjectManifest({
                swSrc: "./src/src-service-worker.js",
                swDest: "service-worker.js",
                exclude: [/\.(?:ini|php|py|gz|htaccess|txt)$/],
            }),
        ] : []),
        new BundleAnalyzerPlugin({ analyzerMode: 'server', generateStatsFile: true }), // server, static, json, disabled
        new MiniCssExtractPlugin(),
        new CompressionPlugin({
            filename: '[path][name].gz[query]',
            algorithm: 'gzip',
            threshold: 10240,
            minRatio: 0.8,
            exclude: /\/lib/,
        }),
        new webpack.DefinePlugin({
            'process.env.FRONTEND_URL': JSON.stringify(process.env.FRONTEND_URL),
            'process.env.BACKEND_URL': JSON.stringify(process.env.BACKEND_URL),
            '__VUE_OPTIONS_API__': JSON.stringify(true), // Habilita la Options API de Vue
            '__VUE_PROD_DEVTOOLS__': JSON.stringify(false), // Deshabilita las Devtools en producción
            '__VUE_PROD_HYDRATION_MISMATCH_DETAILS__': JSON.stringify(false), // Opcional: Detalles de errores de hidratación
        }),
    ], 
    /*watchOptions: {
        ignored: /node_modules|build/, // Ignora cambios en estas carpetas
    },*/
    performance: {
        maxEntrypointSize: 960000,
        maxAssetSize: 960000
    },
}