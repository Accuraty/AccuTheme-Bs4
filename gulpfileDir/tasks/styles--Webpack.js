import webpack from 'webpack';

// How to get around the no named exports from gulp error
import pkg from 'gulp';
const { parallel } = pkg;
import { paths, plugins, project } from '../config/index.js';
import * as WEBPACK_CONFIGS from '../../webpack.SCSS.config.js';

function skinStylesTask() {
  if (!project.styles.skin) return Promise.resolve();
  return new Promise(resolve => {
    webpack(WEBPACK_CONFIGS.skinConfig, (err, stats) => {
      if (err) console.log('Webpack', err);
      resolve();
    });
  });
}

function moduleStylesTask() {
  if (!project.styles.modules) return Promise.resolve();

  return new Promise(resolve => {
    webpack(WEBPACK_CONFIGS.moduleConfig, (err, stats) => {
      if (err) console.log('Webpack', err);
      resolve();
    });
  });
}

function containerStylesTask() {
  if (!project.styles.containers) return Promise.resolve();

  return new Promise(resolve => {
    webpack(WEBPACK_CONFIGS.containerConfig, (err, stats) => {
      if (err) console.log('Webpack', err);
      resolve();
    });
  });
}

const _skinStyles = skinStylesTask;
export { _skinStyles as skinStyles };
const _moduleStyles = moduleStylesTask;
export { _moduleStyles as moduleStyles };
const _containerStyles = containerStylesTask;
export { _containerStyles as containerStyles };

export const styles = parallel(
  skinStylesTask,
  moduleStylesTask,
  containerStylesTask
);
