// How to get around the no named exports from gulp error
// import pkg from 'gulp';
// const { src, dest } = pkg;
import webpack from 'webpack';
import { project } from '../config/index.js';
import WEBPACK_CONFIGS from '../../webpack.stylelint.config.js';

function lintStyles() {
  if (!project.styles) return Promise.resolve();
  return new Promise(resolve => {
      webpack(WEBPACK_CONFIGS, (err, stats) => {
        if (err) console.log('Webpack', err);
        resolve();
      });
    });
}

const _lintStyles = lintStyles;
export { _lintStyles as lintStyles };
