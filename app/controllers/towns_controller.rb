class TownsController < ApplicationController
  autocomplete :town, :name, :extra_data => [:county], :display_value => :identifying_string
end
