class SearchesController < ApplicationController
  def index
    @searches = Search.page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @searches }
    end
  end

  def show
    @search = Search.find params[:id]
    @matches = @search.matches.page(params[:page])

    add_search_bar
  end

  def new
    @search = Search.new
  end

  def create
    Rails.logger.debug params
#    if I do Search.new(params[:search]) then the :init method realises there is a missing value
#    and subs in a default value instead. That means that we can never fail because of blank fields
    @search = Search.new
    @search.update_attributes params[:search]

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
end
