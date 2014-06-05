Ruby Projects Protocol
======================

A guide to work around the hassle of activating the right gem, using
the right ruby, and everything ruby related


Bundle exec and binstubs
------------------------

### Using the global gem executable

If there are different versions of a gem installed in the current ruby, Rubygems
will always choose the latest version.

```shell
$ gem install rake -v 10.3.2
$ gem install rake -v 10.2.2
$ rake --version
rake, version 10.3.2
```

### Using per project gems with bundler

If you have a project with a `Gemfile` file that define a specific gem version,
you'll need to run `bundle exec <gem>` to activate the correct version.

Given this `Gemfile`
```ruby
# A sample Gemfile
source "https://rubygems.org"

gem "rake", "10.2.2"
```

You can choose which version to run

```shell
$ bundle install
....
$ rake --version
rake, version 10.3.2
$ bundle exec rake --version
rake, version 10.2.2
```

It's a little tedious to write `bundle exec` every time. To prevent that, bundler
provides a way to create binstubs for the gem executables.

```shell
$ bundle binstubs rake
$ bin/rake --version
rake, version 10.2.2
```

The `bundle binstubs` command will create a `bin` folder with the corresponding
executable. That folder should be added to the version control of your project.

**Note:** There are a few ways to use the project binstubs directly, but the
bundler authors discourage that. They want you to be able to choose whether you
want to execute the global version with `rake` or the bundled version with `bin/rake`
