source 'http://rubygems.org'

gem 'rails', '3.1.0.rc1'

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
# gem 'aws-s3', :require => 'aws/s3'

# template engines
gem 'haml'
gem 'sass'
gem 'coffee-script'
gem 'uglifier'


gem 'jquery-rails', :git => 'http://github.com/indirect/jquery-rails.git'
gem 'kaminari'
gem 'nokogiri'
gem 'mechanize'
gem 'pg'
gem 'delayed_job'
gem 'hirefire'
gem 'devise'
gem 'texticle'

# this should be moved back into dev after I stop faking data in prod
gem 'faker'

# have this one outside dev so that I can use hirb on heroku console
gem 'hirb'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem 'rspec-rails'
  gem 'annotate'
  gem 'fakeweb'
end

# a comment to make it migrate
group :test do
  gem 'rspec-rails'
  gem 'webrat'
  gem 'capybara', :git => "git://github.com/jnicklas/capybara"
  gem 'spork', '~> 0.9.0.rc'
  gem "launchy"
  gem 'factory_girl_rails'
  gem 'fakeweb'
end
