class LocationsController < ApplicationController
  def index
    params[:search] = {:locations => []} unless params.key?(:search)
    @locations = controlled_search(params[:name], params[:search][:locations])

    respond_to do |format|
      format.html
      format.js
    end
  end

#  TODO searching 'North County Dublin' causes a ton off locations to be added to the towns list
  def controlled_search keyword, exclusions
    keyword = sanitize keyword
#    Rails.logger.debug "County ID's #{county_exclusions(exclusions)}"
#    Rails.logger.debug "Town ID's #{town_exclusions(exclusions)}"
    logger.debug "Keyword '#{keyword}'"
    county_search_results = County.search_except keyword.to_s, county_exclusions(exclusions)
#    Rails.logger.debug "Num of County search results: #{county_search_results.count}"
#    county_search_results.county should be a binary result so this could be better
    return county_search_results if county_search_results.count > 0

    town_search_results = Town.search_except keyword.to_s, town_exclusions(exclusions)
#    Rails.logger.debug "Num of Town search results: #{town_search_results.count}"
    return town_search_results if town_search_results.count > 0

    fuzzy_search_results = Town.tsearch_except keyword.to_s, town_exclusions(exclusions)
#    Rails.logger.debug "Num of Fuzzy Town search results: #{fuzzy_search_results.count}"
    fuzzy_search_results
  end

  def sanitize keywords
    keywords.gsub(/(\banywhere\b|\bin\b|\bCo\.\b|,\b)/, '')
  end

  def county_exclusions exclusions
    @county_exclusions ||= exclusions.select {|id| id[0] == 'c'}.map {|id| id.gsub(/\D/, '').to_i }
  end

  def town_exclusions exclusions
    @town_exclusions ||= exclusions.select {|id| id[0] == 't'}.map {|id| id.gsub(/\D/, '').to_i }
  end
end
