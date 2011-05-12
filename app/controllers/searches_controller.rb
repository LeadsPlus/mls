class SearchesController < ApplicationController
  def index
    @searches = Search.page(params[:page]).per(50)

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @searches }
    end
  end

  def show
    logger.debug "about to retrieve the search"
    @search = Search.find params[:id]
    logger.debug "about to retrieve the matches"
    @all_matches = @search.matches
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
                          :county => "Fermanagh",
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
end
