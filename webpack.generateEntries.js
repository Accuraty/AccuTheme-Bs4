import { resolve, relative, dirname } from 'path';
import { globSync } from 'glob';
import { fileURLToPath } from 'url';
import path from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const generateEntries = () => {
  const images = globSync('./src/media/images/**/*.{png,jpg,jpeg,gif}').reduce(
    (acc, file) => {
      const name = relative('./src/media/images', file).replace(
        /\.[^/.]+$/,
        ''
      );
      acc[name] = resolve(__dirname, file);
      return acc;
    },
    {}
  );

  const svg = globSync('./src/media/svg/**/*.svg').reduce((acc, file) => {
    const name = relative('./src/media/svg', file).replace(/\.[^/.]+$/, '');
    acc[name] = resolve(__dirname, file);
    return acc;
  }, {});

  return {
    ...images,
    ...svg,
  };
};

export default generateEntries;
