class TownsController < ApplicationController
  autocomplete :town, :name, :extra_data => [:region_name], :display_value => :address

  def index
    params[:search] = {:locations => []} unless params.key?(:search)
    if params[:name]
      @towns = Town.controlled_search(params[:name], params[:search][:locations])
    else
      @towns = Town.all
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end