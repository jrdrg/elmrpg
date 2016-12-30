const Webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const AutoPrefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const WebpackMerge = require('webpack-merge');



// copied much of this from https://github.com/benansell/elm-webpack-seed

const common = {
    entry: {
        app: './src/app.js',
        /* vendor: './src/vendor.js'*/
    },

    resolve: {
        modulesDirectories: ['node_modules'],
        extensions: ['', '.js', '.elm']
    },

    module: {
        loaders: [{
            test: /\.(eot|svg|ttf|woff|woff2)(\?v=\d+\.\d+\.\d+)?/,
            loader: 'file-loader'
        }, {
            test: /\.(png|jpg)(\?v=\d+\.\d+\.\d+)?/,
            loader: 'file-loader'
        }],

        noParse: /^(?!.*Stylesheets).*\.elm$/
    },

    plugins: [
        new HtmlWebpackPlugin({
            template: 'src/index.tpl.html'
        }),
        new Webpack.optimize.CommonsChunkPlugin({
            name: "init",
            minChunks: Infinity
        }),
        new Webpack.optimize.OccurenceOrderPlugin()
    ],

    postcss: [AutoPrefixer({
        browsers: ['last 2 versions']
    })],

    target: 'web'
};

function dev() {
    console.log('running development');
    extractCssVendor = new ExtractTextPlugin('vendor.css');

    var devOnly = {
        output: {
            filename: '[name].js'
        },

        module: {
            loaders: [{
                    test: /\.css$/,
                    loader: extractCssVendor.extract('style-loader', 'css-loader')
                },

                {
                    test: /src\/Stylesheets.elm$/,
                    loaders: [
                        'style-loader',
                        'css-loader',
                        'postcss-loader',
                        'elm-css-webpack-loader'
                    ]
                },

                {
                    test: /\.elm$/,
                    exclude: [
                        /elm-stuff/,
                        /node_modules/,
                        /src\/Stylesheets.elm$/
                    ],
                    loaders: [
                        'elm-hot-loader',
                        'elm-webpack-loader?verbose=true&warn=true&debug=false'
                    ]
                }
            ]
        },

        plugins: [
            extractCssVendor
        ],

        devServer: {
            inline: true,
            progress: true,
            stats: 'errors-only'
        }
    };

    return WebpackMerge(common, devOnly);
}

function prod() {
console.log('building for production');
    var extractCssApp = new ExtractTextPlugin('app-[chunkhash].css', {
        allChunks: true
    });
    extractCssVendor = new ExtractTextPlugin('vendor-[chunkhash].css');

    var prodOnly = {
        output: {
            path: './dist',
            filename: '[name]-[chunkhash].min.js',
            chunkFilename: '[name]-[chunkhash].min.js'
        },

        module: {
            loaders: [{
                    test: /\.css$/,
                    loader: extractCssVendor.extract('style-loader', 'css-loader')
                },

                {
                    test: /src\/Stylesheets.elm/,
                    loader: extractCssApp.extract(
                        'style-loader', [
                            'css-loader',
                            'postcss-loader',
                            'elm-css-webpack-loader'
                        ])
                },

                {
                    test: /\.elm$/,
                    exclude: [
                        /elm-stuff/,
                        /node_modules/,
                        /src\/Stylesheets.elm$/
                    ],
                    loader: 'elm-webpack-loader'
                }
            ]
        },

        plugins: [
            new CopyWebpackPlugin([{
                from: 'src/assets',
                to: 'assets'
            }]),
            extractCssApp,
            extractCssVendor,
            new UnminifiedWebpackPlugin(),
            new Webpack.optimize.UglifyJsPlugin({
                compress: {
                  warnings: false,
                  dead_code: true,
                  unused: true
                }
            })
        ]
    };

    return WebpackMerge(common, prodOnly);
}


module.exports = dev();
