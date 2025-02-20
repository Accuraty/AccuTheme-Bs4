// How to get around the no named exports from gulp error
// import pkg from 'gulp';
// const { src, dest } = pkg;
import webpack from 'webpack';
import WEBPACK_CONFIGS from '../../webpack.images.config.js';

function images() {
  return new Promise((resolve, reject) => {
      webpack(WEBPACK_CONFIGS, (error, stats) => {
        if(error || stats.hasErrors())
        {
          let err = error ?? stats.compilation.errors;
          reject(new Error(`Webpack Images Error: ${err}`));
          return;
        }
        resolve();
      });
    });
}

const _images = images;
export { _images as images };
