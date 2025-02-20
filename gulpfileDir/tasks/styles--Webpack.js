import webpack from 'webpack';

// How to get around the no named exports from gulp error
import pkg from 'gulp';
const { parallel } = pkg;
import { paths, plugins, project } from '../config/index.js';
import * as WEBPACK_CONFIGS from '../../webpack.SCSS.config.js';

function skinStylesTask() {
  if (!project.styles.skin) return Promise.resolve();
  return new Promise((resolve, reject) => {
    try
    {
      webpack(WEBPACK_CONFIGS.skinConfig, (error, stats) => {
        if(error || stats.hasErrors())
        {
          let err = error ?? stats.compilation.errors;
          reject(new Error(`Webpack Skin Style Error: ${err}`));
          return;
        }
        resolve();
      });
    }
    catch (err)
    {
      console.log('Webpack', err);
      reject(new Error(`Webpack Skin Style Error: ${err}`));
      return;
    }

  });
}

function moduleStylesTask() {
  if (!project.styles.modules) return Promise.resolve();

  return new Promise((resolve, reject) => {
    webpack(WEBPACK_CONFIGS.moduleConfig, (error, stats) => {
      if(error || stats.hasErrors())
      {
        let err = error ?? stats.compilation.errors;
        reject(new Error(`Webpack Module Style Error: ${err}`));
        return;
      }
      resolve();
    });
  });
}

function containerStylesTask() {
  if (!project.styles.containers) return Promise.resolve();

  return new Promise((resolve, reject) => {
    webpack(WEBPACK_CONFIGS.containerConfig, (error, stats) => {
      if(error)
      {
        let err = error ?? stats.compilation.errors;
        reject(new Error(`Webpack Container Style Error: ${err}`));
        return;
      }
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
