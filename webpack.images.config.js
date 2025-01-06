import { resolve } from 'path';
import ImageMinimizerPlugin from 'image-minimizer-webpack-plugin';
import { fileURLToPath } from 'url';
import path from 'path';
import { globSync } from 'glob';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const dnnThemeDestPath = 'dnn/Portals/_default/Skins';

// Get source files relative to src/media
const imageFiles = globSync('images/**/*.{png,jpg,jpeg,gif}', { cwd: './src/media' }).map(file => `./${file}`);
const svgFiles = globSync('svg/**/*.svg', { cwd: './src/media' }).map(file => `./${file}`);

// Run custom script first
import './webpack.images.info.js';

export default {
  mode: 'production',
  context: resolve(__dirname, 'src/media'),
  entry: {
    images: [...imageFiles, ...svgFiles]
  },
  output: {
    path: resolve(__dirname, dnnThemeDestPath, 'dist/media'),
    clean: true
  },
  module: {
    rules: [{
      test: /\.(png|jpe?g|gif)$/i,
      type: 'asset/resource',
      generator: {
        filename: '[path][name][ext]'
      }
    },
    {
      test: /\.svg$/i,
      type: 'asset/resource',
      generator: {
        filename: '[path][name][ext]'
      }
    }]
  },
  plugins: [
    new ImageMinimizerPlugin({
      minimizer: {
        implementation: ImageMinimizerPlugin.imageminMinify,
        options: {
          plugins: [
            ['mozjpeg', { quality: 75 }],
            ['pngquant', { quality: [0.6, 0.8] }],
            ['svgo', {
              plugins: [{
                name: 'preset-default',
                params: {
                  overrides: {
                    removeViewBox: false
                  }
                }
              }]
            }]
          ]
        }
      }
    })
  ]
};
