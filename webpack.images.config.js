import { resolve } from 'path';
import ImageMinimizerPlugin from 'image-minimizer-webpack-plugin';
import { fileURLToPath } from 'url';
import path from 'path';
import generateEntries from './webpack.generateEntries.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const entries = generateEntries();

const dnnThemeDestPath = 'dnn/Portals/_default/Skins';

export default {
  mode: 'production',
  entry: entries,
  output: {
    path: resolve(__dirname, dnnThemeDestPath, 'dist/media'),
    filename: '[name][ext]', // Output filename pattern
    assetModuleFilename: '[path][name][ext]', // Output asset filename pattern
    clean: true, // Clean the output directory before emit
  },
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif)$/i,
        include: resolve(__dirname, 'src/media/images'),
        type: 'asset/resource', // Use asset/resource for images
      },
      {
        test: /\.svg$/i,
        include: resolve(__dirname, 'src/media/svg'),
        type: 'asset/resource', // Use asset/resource for SVGs
      },
    ],
  },
  plugins: [
    new ImageMinimizerPlugin({
      minimizer: {
        implementation: ImageMinimizerPlugin.imageminMinify,
        options: {
          plugins: [
            ['mozjpeg', { quality: 75 }],
            ['pngquant', { quality: [0.6, 0.8] }],
            [
              'svgo',
              {
                plugins: [
                  {
                    name: 'preset-default',
                    params: {
                      overrides: {
                        removeViewBox: false,
                      },
                    },
                  },
                ],
              },
            ],
          ],
        },
      },
    }),
  ],
};
