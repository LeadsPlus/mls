class TownsController < ApplicationController
#  TODO make it work on the first letter not second
#  TODO look into adding a placeholder value and removing it onfocus with JS
  autocomplete :town, :name, :extra_data => [:county], :display_value => :identifying_string
end