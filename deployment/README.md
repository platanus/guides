# Deploy production rails apps

This is a copy/paste/edit from many sites and guides that I read to get the production server running with apps that could be deployed easily.

At the end of the doc are all the links to the sites I used. [Go there](#references)

## The Server

Create a user that will run all the applications sin this server

#### Install rbenv, ruby, bundler and rails

We start by installing rbenv-installer a nice app that will install `rbenv`, `rbenv-vars` and `rbenv-build` for us

```bash
$ curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
```

Add rbenv to your PATH. The second command adds shims and autocompletion:

```bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
$ echo 'eval "$(rbenv init -)"' >> ~/.profile
```

Reload the profile, install one or more rubies and then rehash to refresh the shims:

```bash
$ source ~/.profile
$ rbenv install 1.9.3-p125
$ rbenv rehash
```

Set your new rbenv ruby as the new system-wide default ruby for this user:

```bash
$ rbenv global 1.9.3-p125
```

Install bundler

```bash
$ gem install bundler
$ rbenv rehash
```

#### Your app

If you don't have and `rbenv-version` or `ruby-version` in your project folder you need to set the ruby version.

```bash
$ rbenv local 1.9.3-p125
```

Install your application dependencies using `--deplayment` and `--binstubs`

```bash
$ cd yourapp
$ bundle install --deployment --binstubs
```

Create a new bin executable for bundle and unicorn or any other app that will run in this environment. You can copy any other file and change what is needed.

For example for unicorn create a `bin/unicorn` file

```ruby
#!/usr/bin/env ruby
require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path("../../Gemfile",
    Pathname.new(__FILE__).realpath)

require 'rubygems'
require 'bundler/setup'

load Gem.bin_path('unicorn', 'unicorn')
```

#### Nginx

Install nginx

```bash
$ add-apt-repository ppa:nginx/stable
$ apt-get update
$ apt-get -y install nginx git-core build-essential
```

Now we can setup our app. We will assume that you have a versioned copy of a `nginx.conf` in your `config` folder. Also you can check a [sample][nginx-file] of this config file

```bash
$ cd /etc/nginx/sites-enabled
$ sudo ln -s path/to/my/app/config/nginx.conf myappname
$ sudo service nginx reload
```

note: you can test your nginx config using `sudo nginx -t` command

#### Unicorn

Install unicorn

```bash
$ gem install unicorn --no-rdoc --no-ri
$ rbenv rehash
```

Adds unicorn as a production gem in the `GemFile`

```ruby
group :production do
  gem 'unicorn'
end
```

Add a Unicorn configuration to your app in the file `config/unicorn.rb`. You can use this [sample][unicorn-file]

Now you should be able to run the unicorn server with your app

```bash
$ bundle exec bin/unicorn -c config/unicorn.rb -E production -D
```

The log files in `unicorn/err.log` should be helpful to debug any problems.

#### Monitoring processes

We need to monitor the unicorn processes and any other processes we might use in our apps. For this task we are going to use a gem named bluepill.

Install bluepill, you'll also need to create the run directory for bluepill and give the web user permissions over it.

```bash
$ gem install bluepill
$ sudo mkdir /var/run/bluepill
$ sudo chown web:root /var/run/bluepill
```

Create a pill configuration file. You can use this [sample][unicorn-pill-file]

Then you can run the pill.

```bash
$ cd path/to/app
$ bluepill load config/unicorn.pill --no-privileged
```


#### References
http://henriksjokvist.net/archive/2012/2/deploying-with-rbenv-and-capistrano
http://airbladesoftware.com/notes/rbenv-in-production
http://www.harryyeh.com/2012/10/redmine-setup-with-nginx-unicorn-rbenv.html
https://github.com/sstephenson/rbenv/wiki/Deploying-with-rbenv
https://github.com/sstephenson/rbenv/issues/101
http://sirupsen.com/setting-up-unicorn-with-nginx/
http://blog.halftoneapp.com/unicorn-bluepill-nginx/
http://devmull.net/articles/unicorn-resque-bluepill

http://www.blogsplat.com/past/2010/3/1/bluepill_upstart_and_delayed_job/
http://blog.plataformatec.com.br/2010/02/monitoring-delayed-job-with-bluepill-and-capistrano/

[unicorn-file]: unicorn.rb
[nginx-file]: nginx.conf
[unicorn-pill-file]: unicorn.pill
