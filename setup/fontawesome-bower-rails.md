## How to setup font-awesome when working with bower and rails

The following is basically what the `font-awesome` gem does when included in the proyect (except for step 1 of course).

1. Include `font-awesome` in bower manifest

```
bower install font-awesome --save
```

2. Include font files in the asset pipeline

Add the following code snippet to your `application.rb` or `production.rb`

```ruby
config.assets.precompile << Proc.new { |path| path =~ /font-awesome\/fonts/ and File.extname(path).in?(['.otf', '.eot', '.svg', '.ttf', '.woff']) }
```

3. Modify the `@font_face` variable to use the assets urls

Create a new .less stylesheet asset with the following content (for sass just use sass syntax):

```less
@font-face {
  font-family: 'FontAwesome';
  src: font-url('font-awesome/fonts/fontawesome-webfont.eot?v=@{fa-version}');
  src: font-url('font-awesome/fonts/fontawesome-webfont.eot?#iefix&v=@{fa-version}') format('embedded-opentype'),
  font-url('font-awesome/fonts/fontawesome-webfont.woff?v=@{fa-version}') format('woff'),
  font-url('font-awesome/fonts/fontawesome-webfont.ttf?v=@{fa-version}') format('truetype'),
  font-url('font-awesome/fonts/fontawesome-webfont.svg?v=@{fa-version}#fontawesomeregular') format('svg');
  font-weight: normal;
  font-style: normal;
}
```

Then include it in your main `aplication.less` file under the font-awesome css inclusion:

```less
@import "font-awesome/less/font-awesome";
@import "font-paths";
```

