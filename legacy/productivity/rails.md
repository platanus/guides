# Some useful productivity tools and tips when using Ruby on Rails
(many details only apply to OS X)

## General Tools

### [rbenv](https://github.com/sstephenson/rbenv) ruby version manager
You'd also like to install ruby-build, that automates the installation of new ruby versions.
~~~
$ brew update
$ brew install rbenv
$ brew install ruby-build
$ rbenv install 1.9.3-p327
$ rbenv rehash
~~~
Then you can use `rbenv local 1.9.3-p327` to define that version in the current directory (a `.ruby-version` file will be created), or you can use `rbenv global 1.9.3-p327` to use it globally.

### [rbenv-bundler](https://github.com/carsomyr/rbenv-bundler) no more `bundle exec`
This saves you from typing `bundle exec` when you are using bundle. It slows down your shell initialization, so don't close them that often.

### [zeus](https://github.com/burke/zeus) faster rails
zeus s
zeus c
zeus rake

## Testing
### [guard-rspec](https://github.com/guard/guard-rspec)
gem 'terminal-notifier-guard'
gem 'rb-fsevent'


### [factory-girl]


### [spork](https://github.com/sporkrb/spork)
gem 'spork-rails'

## Deployment

### [negroku](https://github.com/platanus-repos/negroku)

## Documentation
### rails-erd

## Frontend
### LiveReload
gem 'guard-livereload'