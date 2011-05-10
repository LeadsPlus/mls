# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mls::Application.initialize!

if $0 == 'irb'
  require 'hirb'
  Hirb.enable
end