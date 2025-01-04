// How to get around the no named exports from gulp error
import pkg from 'gulp';
const { src, dest, parallel } = pkg;

import { paths, plugins, project } from '../config/index.js';
const { fonts, svg } = paths;
const $ = plugins.imagemin;

function fontsTask() {
  if (!project.fonts) return Promise.resolve();
  return src(fonts.src).pipe(dest(fonts.dist));
}

function svgTask() {
  if (!project.svg) return Promise.resolve();
  return src(svg.src).pipe(dest(svg.dist));
}

function videosTask() {
  if (!project.videos) return Promise.resolve();
  return src(paths.videos.src).pipe(dest(paths.videos.dist));
}

export const media = parallel(fontsTask, svgTask, videosTask);
