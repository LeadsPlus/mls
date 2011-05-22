class SearchesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :index ]
#  so that we can access these methods in the view layer
  helper_method :sort_column, :sort_direction

  def index
    @searches = Search.page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @searches }
    end
  end

  def show
    @search = Search.find params[:id]

#    if there is no sorting cookie, set one with defaults
#    if we call the show action with params, use them to change the cookie values
#    reload the show with the cookie values controlling order

    @all_matches = @search.matches.order(sort_column + " " + sort_direction)
    @matches = @all_matches.page(params[:page])
    @rate = @search.rate

    add_search_bar
  end

  def new
#    I think that the problem here will be that these will overwrite the fields that
#    caused errors when we render new from the create failure action???
    @search = Search.new( :min_payment => 700,
                          :max_payment => 1200,
                          :term => 25,
                          :deposit => 50000,
                          :location => "Fermanagh",
                          :lender => 'Any',
                          :loan_type => 'Any', :initial_period_length => 0)
  end

  def create
    @search = Search.new params[:search]

    if @search.save
      redirect_to search_path(@search)
    else
      render 'new'
    end
  end

  private
    def add_search_bar
      @search_form = true
    end

#   set defaults for the sorting params for when they're not in the url
#   also, if the user sets default sorting options, store them in a cookie so they persist
#   between searches.
    def sort_column
#     sanitize the direction parameter to prevent SQL inj
      if params[:sort] && House.column_names.include?(params[:sort])
        cookies[:sort] = { value: params[:sort], expires: 1.year.from_now } unless cookies[:sort] == params[:sort]
        cookies[:sort]
      elsif cookies[:sort]
        cookies[:sort]
      else
        'price'
      end
    end

    def sort_direction
      if params[:direction] && %w[asc desc].include?(params[:direction])
        cookies[:direction] = { value: params[:direction], expires: 1.year.from_now } unless cookies[:direction] == params[:direction]
        cookies[:direction]
      elsif cookies[:direction]
        cookies[:direction]
      else
        'desc'
      end
    end
end
