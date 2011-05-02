class SearchesController < ApplicationController
  def show
    @search = Search.find params[:id]
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
