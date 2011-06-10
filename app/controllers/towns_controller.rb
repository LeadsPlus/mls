# TODO form error handling

class TownsController < ApplicationController
  autocomplete :town, :name, :extra_data => [:county], :display_value => :address

  def index
    params[:search] = {:location => []} unless params.key?(:search)
    if params[:name]
      @towns = Town.search_except(params[:name], params[:search][:location])
    else
      @towns = Town.all
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end