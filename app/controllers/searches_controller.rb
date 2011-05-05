class SearchesController < ApplicationController
  def index
    @searches = Search.page(params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @searches }
    end
  end

  def show
    @search = Search.find params[:id]
    @matches = @search.matches.page(params[:page]).per(30)
  end

  def new
    @search = Search.new
  end

  def create
    Rails.logger.debug params
    @search = Search.new(params[:search])

    if @search.save
      redirect_to search_path(@search)
    else
      render 'new'
    end
  end
end
