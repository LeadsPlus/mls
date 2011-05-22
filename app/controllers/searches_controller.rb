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
    def sort_column
#      I'm going to have to retreive the default sort column from a cookie or from seesion
#      to allow it to persist from page to page
#      perhaps a gem can do this for me instead?
      House.column_names.include?(params[:sort]) ? params[:sort] : "price"
    end

    def sort_direction
#     sanitize the direction parameter to prevent SQL inj
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
