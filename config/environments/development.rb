Mls::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
#  set this to true when updating to rails 3.1.0.rc1 because of error:
#  /Users/davidtuite/.rvm/gems/ruby-1.9.2-head@mls_gems/gems/actionpack-3.1.0.rc1/lib/action_view/railtie.rb:34:in `block (3 levels) in <class:Railtie>': undefined method `debug_rjs=' for ActionView::Base:Class (NoMethodError)
#  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

#  mailer config for devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

