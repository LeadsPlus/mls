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
    @search = Search.includes(:rate).find(params[:id])
    @matches = @search.matches.includes(:photos, :property_type)
                      .order(sort_column + " " + sort_direction).page(params[:page])
    @rate = @search.rate

    add_search_bar

    respond_to do |format|
      format.html
      format.xml { render :xml => @matches }
      format.js
    end
  end

  def new
    render :layout => 'single_column'
  end

  def create
    @search = Search.new params[:search]
    @usage = Usage.find_or_create_by_identifier(ip_address: request.ip, user_agent: request.headers['HTTP_USER_AGENT'])

    if @search.save
      respond_to do |format|
        format.html { redirect_to search_path(@search) }
        format.js do
          @matches = @search.matches.order(sort_column + " " + sort_direction).page(params[:page])
          @rate = @search.rate
#          this could also be done like this..
#          render partial: 'shared/results', locals: { matches: @matches, rate: @rate }, layout: false
#          this would leave me with less js files to look after and I could handle the html on the client
#          of course, I also couldn't use coffeescript
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
