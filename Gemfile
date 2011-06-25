source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'
gem 'rake', '0.8.7'

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


gem 'jquery-rails', :git => 'https://github.com/indirect/jquery-rails.git'
gem 'kaminari'
gem 'nokogiri', '1.4.6'
gem 'mechanize'
gem 'pg'
gem 'delayed_job', git: 'https://github.com/collectiveidea/delayed_job.git', tag: 'v2.1.2'
gem 'devise'
gem 'texticle'
gem 'rails3-jquery-autocomplete'

# this should be moved back into dev after I stop faking data in prod
gem 'faker'

# have this one outside dev so that I can use hirb on heroku console
gem 'hirb'

group :production do
#  gem 'therubyracer-heroku', '0.8.1.pre3'
#  hirefire gem needs to load after delayed_job
  gem 'hirefire'
end

group :development do
  gem 'rspec-rails' #, :git => 'https://github.com/dchelimsky/rspec-rails.git'
  gem 'annotate'
  gem 'fakeweb'
end

# a comment to make it migrate
group :test do
  gem 'rspec-rails' #, :git => 'https://github.com/dchelimsky/rspec-rails.git'
#  gem 'webrat'
  gem 'capybara', :git => "https://github.com/jnicklas/capybara.git", tag: '0.4.1.2'
  gem 'spork' #, '~> 0.9.0.rc'
  gem "launchy"
  gem 'factory_girl_rails'
  gem 'fakeweb'
  gem 'database_cleaner', :git => 'https://github.com/bmabey/database_cleaner.git'
end
