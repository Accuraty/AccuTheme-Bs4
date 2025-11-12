module.exports = function (source) {
  source = source.replace(
    /\<package name\=\"(.*?)(?=\")/,
    '<package name="AccuTheme-Bs4'
  );
  source = source.replace(
    /type\=\"Skin\" version\=\"(.*?)(?=\")/,
    'type="Skin" version="1.0.2'
  );
  source = source.replace(
    /\<friendlyName\>(.*?)(?=\<)/,
    '<friendlyName>AccuTheme-Bs4</friendlyName>'
  );
  source = source.replace(
    /\<description\>(.*?)(?=\<)/,
    '<description>A DNN Theme created by Accuraty.'
  );
  source = source.replace(/\<name\>(.*?)(?=\<)/, '<name>Accuraty');
  source = source.replace(
    /\<organization\>(.*?)(?=\<)/,
    '<organization>Accuraty'
  );
  source = source.replace(/\<url\>(.*?)(?=\<)/, '<url>https://accuraty.com/');
  source = source.replace(/\<email\>(.*?)(?=\<)/, '<email>info@accuraty.com');
  source = source.replace(/\<skinName\>(.*?)(?=\<)/, '<skinName>AccuTheme-Bs4');
  source = source.replace(/(\\Skins\\)(.*?)(?=\\)/g, '\\Skins\\AccuTheme-Bs4');
  source = source.replace(
    /(\\Containers\\)(.*?)(?=\\)/g,
    '\\Containers\\AccuTheme-Bs4'
  );
  return `${source}`;
};
