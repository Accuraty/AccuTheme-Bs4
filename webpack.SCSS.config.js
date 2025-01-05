// This needs to be the very first import so that it is the first to run,
// otherwise the env global variable might not contain the contents of the .env file.
import './gulpfileDir/config/envLoader.js';
import path, { resolve } from 'path';
import {
  skinStyles,
  moduleStyles,
  containerStyles,
} from './gulpfileDir/config/paths.js';
/*
  Used to dynamically create a key:value mapping from found entry files where the key is the filename without extension.
  This is needed because the name token in "filename: '[name].css'" is the key in the mappings.
*/
import { glob } from 'glob';
import autoprefixer from 'autoprefixer';

// ES6 doesn't have __filename or __dirname global variables so this creates them for us.
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Dynamically set entry points for all JS files in the src directory
const skinFiles = glob.sync(skinStyles.src).reduce((entries, file) => {
  // Use the file name (excluding the path) as the key for entry
  const entryName = path.basename(file, '.scss');
  entries[entryName] = `./${file}`; //Have to add ./ or else webpack will think it is a module
  return entries;
}, {});
const moduleFiles = glob.sync(moduleStyles.src).reduce((entries, file) => {
  // Use the file name (excluding the path) as the key for entry
  const entryName = path.basename(file, '.scss');
  entries[entryName] = `./${file}`; //Have to add ./ or else webpack will think it is a module
  return entries;
}, {});
/* eslint-disable */ //filename length makes linter want to format this differently than above so turning off to keep same styling
const containerFiles = glob.sync(containerStyles.src).reduce((entries, file) => {
  // Use the file name (excluding the path) as the key for entry
  const entryName = path.basename(file, '.scss');
  entries[entryName] = `./${file}`; //Have to add ./ or else webpack will think it is a module
  return entries;
}, {});
/* eslint-enable */

//Array of configs for the webpack version of the skinStylesTask, moduleStylesTask, and containerStylesTask
// Need to figure out how to trigger all 3 in parallel for stand alone webpack
const skinConfig = {
  //Skin Styles
  mode: 'production',
  // stats: 'verbose',
  entry: skinFiles,
  output: {
    path: resolve(__dirname, `${skinStyles.dist}`),
    // filename: 'test/[name].css', // Output JS file name based on file name
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        type: 'asset/resource',
        generator: {
          filename: '[name].css',
        },
        use: [
          {
            loader: 'postcss-loader', // Run PostCSS on the CSS
            options: {
              postcssOptions: {
                plugins: [
                  [
                    autoprefixer, // Add vendor prefixes automatically
                  ],
                ],
              },
            },
          },
          'sass-loader',
        ],
      },
    ],

  },
};

const moduleConfig = {
  //Module Styles
  mode: 'production',
  entry: moduleFiles,
  output: {
    path: resolve(__dirname, `${moduleStyles.dist}`),
    // filename: '[name].css', // Output JS file name based on file name
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        type: 'asset/resource',
        generator: {
          filename: '[name].css',
        },
        use: [
          {
            loader: 'postcss-loader', // Run PostCSS on the CSS
            options: {
              postcssOptions: {
                plugins: [
                  [
                    autoprefixer, // Add vendor prefixes automatically
                  ],
                ],
              },
            },
          },
          'sass-loader',
        ],
      },
    ],
  },
};

const containerConfig = {
  // Container Styles
  mode: 'production',
  entry: containerFiles,
  output: {
    path: resolve(__dirname, `${containerStyles.dist}`),
    // filename: '[name].css', // Output JS file name based on file name
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        type: 'asset/resource',
        generator: {
          filename: '[name].css',
        },
        use: [
          {
            loader: 'postcss-loader', // Run PostCSS on the CSS
            options: {
              postcssOptions: {
                plugins: [
                  [
                    autoprefixer, // Add vendor prefixes automatically
                  ],
                ],
              },
            },
          },
          'sass-loader',
        ],
      },
    ],
  },
};

export default skinConfig;
export { skinConfig, moduleConfig, containerConfig };
