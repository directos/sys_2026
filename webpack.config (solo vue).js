const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  mode: "development",
  entry: "./src/frontend/main.js", // Archivo de entrada principal
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
    clean: true, // Limpia la carpeta dist antes de cada build
  },
  devServer: {
    static: {
      directory: path.join(__dirname, "dist"),
    },
    port: 8080, // Puerto del servidor de desarrollo
    open: true, // Abre el navegador automáticamente
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: "vue-loader",
      },
      {
        test: /\.css$/,
        use: ["vue-style-loader", "css-loader"],
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
        },
      },
    ],
  },
  resolve: {
    alias: {
      vue$: "vue/dist/vue.esm-bundler.js",
    },
    extensions: ["*", ".js", ".vue", ".json"],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./index.html", // Archivo HTML base
    }),
    new (require("vue-loader").VueLoaderPlugin)(),
  ],
};