require 'locations_search'

class LocationsController < ApplicationController
  def index
    params[:search] = {:locations => []} unless params.key?(:search)
    @locations = LocationsSearch.new(params[:name], params[:search][:locations]).controlled_search

    respond_to do |format|
      format.js
    end
  end
end
