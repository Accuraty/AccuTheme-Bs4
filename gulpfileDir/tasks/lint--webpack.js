// How to get around the no named exports from gulp error
// import pkg from 'gulp';
// const { src, dest } = pkg;
import webpack from 'webpack';
import { project } from '../config/index.js';
import WEBPACK_CONFIGS from '../../webpack.stylelint.config.js';

function lintStyles() {
  if (!project.styles) return Promise.resolve();
  return new Promise((resolve, reject) => {
      webpack(WEBPACK_CONFIGS, (error, stats) => {
        if(error || stats.hasErrors())
        {
          let err = error ?? stats.compilation.errors;
          reject(new Error(`Webpack Stylelint Error: ${err}`));
          return;
        }
        resolve();
      });
    });
}

const _lintStyles = lintStyles;
export { _lintStyles as lintStyles };
