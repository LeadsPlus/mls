require 'locations_search'

class LocationsController < ApplicationController
  def index
    params[:search] = {:locations => []} unless params.key?(:search)
    log_request params[:name], params[:search][:locations]
    @locations = LocationsSearch.new(params[:name], params[:search][:locations]).controlled_search

    respond_to do |format|
      format.js
    end
  end

  def log_request(search_string, exclusions)
    Logger.new('log/locations_searches.log').info "Search: #{search_string} | Exclusions: #{exclusions.inspect} | From IP: #{request.ip} | UA: #{request.headers['HTTP_USER_AGENT']}"
  end
end
