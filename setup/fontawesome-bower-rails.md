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

3. Modify the `fa-font-path` variable to use the assets urls

Create a new .less or .scss stylesheet asset with the following content:

Less

```less
@fa-font-path: "font-awesome/fonts";
```

SCSS

```scss
$fa-font-path: "font-awesome/fonts";
```

Then include it in your main `aplication.(less|scss)` file under the font-awesome css inclusion:

```less
@import "font-paths";
@import "font-awesome/less/font-awesome";
```
