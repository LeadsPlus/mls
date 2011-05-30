class SearchesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :index ]
#  so that we can access these methods in the view layer
  helper_method :sort_column, :sort_direction
  autocomplete :town, :name #, :display_value => :address

  def index
    @searches = Search.page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @searches }
    end
  end

  def show
    @search = Search.find params[:id]
    @matches = @search.matches.order(sort_column + " " + sort_direction).page(params[:page])
    @rate = @search.rate

    add_search_bar

    respond_to do |format|
      format.html
      format.xml { render :xml => @matches }
      format.js
    end
  end

  def start
    @search = Search.new( :min_payment => 800,
                          :max_payment => 1100,
                          :term => 230,
                          :deposit => 50000,
                          :location => "Enniskillen",
                          :lender => LENDERS,
                          :loan_type => LOAN_TYPES)
  end

  def new
#    I think that the problem here will be that these will overwrite the fields that
#    caused errors when we render new from the create failure action???
    @search = Search.new( :min_payment => 800,
                          :max_payment => 1100,
                          :term => 30,
                          :deposit => 50000,
                          :location => "Enniskillen",
                          :lender => LENDERS,
                          :loan_type => LOAN_TYPES)
  end

  def create
    @search = Search.new params[:search]

    if @search.save
      respond_to do |format|
        format.html { redirect_to search_path(@search) }
        format.js do
          @matches = @search.matches.order(sort_column + " " + sort_direction).page(params[:page])
          @rate = @search.rate
        end
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.js { render 'create_failure' }
      end
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
