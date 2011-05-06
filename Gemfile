source 'http://rubygems.org'

gem 'rails', '3.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem 'haml'
gem 'sass'
gem 'jquery-rails'
gem 'kaminari'
gem 'nokogiri'
gem 'mechanize'
gem 'pg', '0.10.1'

# this should be moved back into dev after I stop faking data in prod
gem 'faker', "0.9.5" #, '0.3.1', :require => false

# have this one outside dev so that I can use hirb on heroku console
gem 'hirb'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem 'rspec-rails', '2.5.0'
  gem 'annotate', '2.4.0'
end

group :test do
  gem 'rspec-rails', '2.5.0'
  gem 'capybara', :git => "git://github.com/jnicklas/capybara", :tag => "0.4.1.2"
  gem 'spork'
  gem "launchy", "0.3.0"
  gem 'factory_girl_rails', "1.0.1"
end
