# jekyll-fontello

[![CircleCI](https://circleci.com/gh/ericcornelissen/jekyll-fontello.svg?style=svg)](https://circleci.com/gh/ericcornelissen/jekyll-fontello)

Jekyll plugin that automatically downloads your webfont from Fontello.

## Installation

1. Install the `jekyll-fontello` gem:
```
gem install jekyll-fontello
```
2. Add `jekyll-fontello` to the list of gems in `_config.yml`:
```yaml
gems: ["jekyll-fontello"]
```
3. Add a Fontello configuration file named `fontello_config.json` to your project.
4. Use Fontello icons on your website or blog!

_Or_ copy `lib/jekyll-fontello.rb` into your `_plugins` directory.

## Options

#### Config file

Change the name/path of the Fontello configuration file, the default value is `'fontello_config.json'`.

```yaml
fontello:
  config: 'config.json'
```

#### Output fonts

Change the output path of the font files, the default value is `'fontello/fonts'`.

```yaml
fontello:
  output_fonts: 'assets/fonts/fontello'
```

#### Output stylesheets

Change the output path of the stylesheet files, the default value is `'fontello/styles'`.

```yaml
fontello:
  output_styles: 'styles/fontello'
```

#### Custom fonts path

The path to the font files that should be put in the stylesheets By default this is computed as the relative path from `output_styles` to `output_fonts`.

```yaml
fontello:
  fonts_path: '/assets/fonts/fontello'
```

#### Preprocessor

Change what CSS preprocessor is used, by default no preprocessor is used. Allowed values are `'none'`, `'less'` and `'scss'`.

```yaml
fontello:
  preprocessor: 'scss'
```
