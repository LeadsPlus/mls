class TownsController < ApplicationController
  autocomplete :town, :name, :extra_data => [:county], :display_value => :address

#  TODO this search should be refactored out of here because it's not only dealing with towns any more
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