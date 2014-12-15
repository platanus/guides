# configure rails_root folder as source path for copying files
#
# check http://technology.stitchfix.com/blog/2014/01/06/rails-app-templates/
# for more information
def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]   +
    [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root', 'config')]
end

remove_file "README.rdoc"
create_file "README.md", "TODO: write an awesome README file"
create_file ".rbenv-vars"
template '.rbenv-vars.example'
create_file ".ruby-version", "2.0.0-p353"
copy_file '.editorconfig'

# Adds database gem and config
# params
#   name: the name of the database
#   gem_name: the name of the gem for that database
def ask_for_database db
  if not @db_setted and yes?("Are you going to use #{db[:name]}?")
    # Save the db to use
    @db_setted = true

    # Set settings con config/database.yml
    inside 'config' do
      remove_file 'database.yml'
      copy_file "database_#{db[:name]}.yml", 'database.yml'
    end

    # Adds the gem to the Gemfile
    gem db[:gem_name]
    gsub_file('Gemfile', /^(gem \"#{db[:gem_name]}\".*)/){ |*match|
      "# Use #{db[:name]} as the database for Active Record\n#{match[0]}\n"
    }

    # Remove default sqlite gem
    gsub_file 'Gemfile', /.*sqlite.*\n*/, ''
  end
end

# Adds devise gem
def ask_for_devise
  if yes?("Are you going to use devise? (needed for active admin)")
    # Adds the gem to the Gemfile
    gem 'devise'
    @use_devise = true
  end
end

# Adds activeadmin gem
def ask_for_active_admin
  if @use_devise and yes?("Are you going to use active_admin?")
    # Adds the gem to the Gemfile
    gem 'activeadmin', github: 'gregbell/active_admin'
    @use_activeadmin = true
  end
end

ask_for_database name: 'mysql', gem_name: 'mysql2'
ask_for_database name: 'postgresql', gem_name: 'pg'
ask_for_devise
ask_for_active_admin

gem_group :development, :test do
  gem "rspec-rails"
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'zeus'
  gem 'guard-rspec', require: false
  gem 'rspec-nc', require: false
  gem 'pry-rails'
  gem 'faker'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'shoulda-matchers'
end

run "bundle install"

generate "rspec:install"
comment_lines 'spec/spec_helper.rb', "require 'rspec/autorun'"
inject_into_file 'spec/spec_helper.rb', "\n  config.include FactoryGirl::Syntax::Methods\n", after: "config.order = \"random\"\n"

run "bundle binstubs guard"
run "guard init rspec"
gsub_file 'Guardfile', 'guard :rspec do', "guard :rspec, cmd: 'zeus rspec' do"

append_to_file '.rspec', "--format=doc\n--format=Nc"

run "bundle install"
run "rails generate devise:install" if @use_devise
run "rails generate active_admin:install" if @use_activeadmin

append_to_file '.gitignore', ".rbenv-vars\n"
append_to_file '.gitignore', ".powder\n"

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
