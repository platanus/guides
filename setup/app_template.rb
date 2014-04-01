# configure rails_root folder as source path for copying files
#
# check http://technology.stitchfix.com/blog/2014/01/06/rails-app-templates/
# for more information
def source_paths
  Array(super) + 
    [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

remove_file "README.rdoc"
create_file "README.md", "TODO: write an awesome README file"
create_file ".rbenv-vars"
template '.rbenv-vars.example'
create_file ".ruby-version", "2.0.0-p353"

gem_group :development, :test do
  gem "rspec-rails"
  gem 'factory_girl_rails'
  gem 'debugger', require: 'ruby-debug'
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

append_to_file '.gitignore', '.rbenv-vars'
append_to_file '.gitignore', '.ruby-version'

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
