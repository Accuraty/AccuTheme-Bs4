// This needs to be the very first import so that it is the first to run,
// otherwise the env global variable might not contain the contents of the .env file.
import './gulpfileDir/config/envLoader.js';
import path from 'path';
import { paths } from './gulpfileDir/config/index.js';
import StylelintPlugin from 'stylelint-webpack-plugin';
import stylelintFormatter from 'stylelint-formatter-pretty';

// ES6 doesn't have __filename or __dirname global variables so this creates them for us.
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Main Webpack config that only runs stylelint and fixes .scss files in-place under .src/styles
const styleConfig = {
  //Skin Styles
  mode: 'production',
  entry: './src/webpack-null-entry.js',
  module: {
    rules: [
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        use: [],
      },
    ],

  },
  plugins: [
    new StylelintPlugin({
      formatter: stylelintFormatter,
      configFile: path.resolve(__dirname, '.stylelintrc.json'),
      context: path.resolve(__dirname, paths.styles.srcDir),
      files: '**/*.scss',
      syntax: 'scss',
      failOnError: false,
      quiet: true,
      fix: true,
      // outputReport: { // Generates report of stylelint errors
      //   filePath: path.resolve(__dirname, `${paths.src}/${paths.styles.dir}/stylelint-report.json`), // Output the lint results to a JSON file
      //   formatter: 'json' // Format the report as JSON
      // }
    }),
  ],
};

export default styleConfig;
