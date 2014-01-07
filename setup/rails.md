## Rails new-app setup guide

### Creating the application

The most common gems and initial configurations are included in a new app by using our [application template](/setup/app_template.rb). In order to use the template we need to pass it as an option to the `rails new` command, like this:

`rails new APP_NAME -m https://raw.github.com/platanus/guides/master/setup/app_template.rb --skip-test-unit`

Note that we're skipping the default generation of the testing resources, since we'll be using `rspec` instead.

One way to avoid always passing these options is by using a `.railsrc` file in your home directory, like [this one](https://github.com/aarellano/dotfiles/blob/master/.railsrc)

### Setup .rbenv-vars

I usualy put development and testing db credentials in the same var.
Services credentials such as SES or Facebook are also set up here.

    DEV_DB_NAME=XXX
    DEV_DB_USER=root
    DEV_DB_PASSWORD=XXXX

### Setup database
**TODO: modifies the database.yml file using the application template**

Setup database.yml so it uses env

    development:
      adapter: mysql2
      encoding: utf8
      database: <%= ENV['DEV_DB_NAME'] %>
      pool: 5
      username: <%= ENV['DEV_DB_USER'] %>
      password: <%= ENV['DEV_DB_PASSWORD'] %>

    test:
      adapter: mysql2
      encoding: utf8
      database: <%= ENV['DEV_DB_NAME'] %>_test
      pool: 5
      username: <%= ENV['DEV_DB_USER'] %>
      password: <%= ENV['DEV_DB_PASSWORD'] %>

    production:
      adapter: mysql2
      encoding: utf8
      database: <%= ENV['PROD_DB_NAME'] %>
      pool: 5
      username: <%= ENV['PROD_DB_USER'] %>
      password: <%= ENV['PROD_DB_PASSWORD'] %>
      host: <%= ENV['PROD_DB_HOST'] %>

Generate databases

    rake db:create

### Setup application.rb

First thing is to disable some generators

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.model_specs false
      g.controller_specs false
      # g.template_engine :rabl # This does not exist...
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end

Also disable initialize on precompile if in heroku

    config.assets.initialize_on_precompile = false

### Setup mailing using SES (if required)

Add the _ses_ and _mail_view_ gems to the gemfile

    gem 'aws-ses', '~> 0.4.1', :require => 'aws/ses'
    gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'

Setup ses as delivery method (in application.rb or individual env)

    config.action_mailer.delivery_method = :ses

Add the ses credentials to a initializer (ses.rb)

    ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
      :access_key_id => ENV['SES_KEY_ID'],
      :secret_access_key => ENV['SES_ACCESS_KEY']

Create the app mailer (maybe with another name...)

    class AppMailer < ActionMailer::Base
      default :from => "contacto@interkambio.cl"

      ## Email previewer (only development)
      class Preview < MailView
        # put preview methods here, every method should return a non delivered mail
        def some_mail; ::AppMailer.some_mail Model.new end
      end
    end

Setup the mail_view preview routes in routes.rb

    if Rails.env.development?
      mount AppMailer::Preview => 'preview_mail'
    end

And add

### Setup delayed job (if required)

Add the dj gem to the gemfile

    gem 'delayed_job_active_record'

Run the dj generator

    rails generate delayed_job:active_record
    rake db:migrate

### Setup authorization using devise

### Setup authorization using custom helper.

### Setup access using canned.

### Setup api base controller.

### Setup json responses (if building an API)

First add formats to wrap_parameters.rb

    ActiveSupport.on_load(:action_controller) do
      wrap_parameters format: [:json, :multipart_form, :url_encoded_form]
    end

Include the rabl gem in the Gemfile

    gem 'rabl'

Add a rable initializer (rabl.rb)

    Rabl.configure do |config|
      config.include_json_root = false
      config.include_child_root = false
    end

### Setup heroku

Add ruby version to gemfile

    ruby '1.9.3'

Add heroku group to gemfile

    group :heroku do
      gem 'pg'
      gem 'unicorn'
    end

Copy production.rb to heroku.rb

Remember to disable initialize on precompile (at least for heroku.rb)

    config.assets.initialize_on_precompile = false

Set heroku as the server enviroment setting RACK_ENV=heroku and RAILS_ENV=heroku

Setup the procfile.
