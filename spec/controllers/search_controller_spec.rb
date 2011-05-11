require 'spec_helper'

describe SearchesController do
  render_views
  before(:each) do
    @rate = Factory :rate
  end

  describe "GET index" do
    before(:each) do
      @search = Factory :search
    end

    it "should be success" do
      get 'index'
      response.should be_success
    end

    it "should list searches" do
      get 'index'
      response.should have_selector("tr#search-#{@search.id}")
    end
  end

  describe "GET show" do
    before(:each) do
      @search = Factory :search
    end
    
    it "should be success" do
      get 'show', :id => @search
      response.should be_success
    end

    describe "when there are matches" do
      before(:each) do
        @match = Factory :house
      end

      it "should list matches" do
        get 'show', :id => @search
        response.should have_selector('tr.house')
      end
    end

    describe "when there are no matches" do
#      we haven't made any houses in this instance
      
      it "should say so" do
        get 'show', :id => @search
        response.should have_selector('div', :content => 'sorry but no houses')
      end
    end
  end

  describe "POST create" do
    describe "success" do
      before(:each) do
        @attr = {
          :deposit => 40_000,
          :min_payment => 1_000,
          :max_payment => 1_300,
          :term => 30,
          :county => "Wicklow",
          :initial_period_length => '',
          :loan_type => 'Any',
          :lender => 'Any'
        }
      end

      it "should create a search" do
        lambda {
          post 'create', :search => @attr
        }.should change(Search, :count).by(1)
      end

      it "should redirect to the search show page" do
        post 'create', :search => @attr
        response.should redirect_to(assigns :search)
      end
    end

    describe "failure" do
      before(:each) do
        @fail_attr = {
          :deposit => '',
          :min_payment => -234,
          :max_payment => '',
          :term => '',
          :county => '',
          :initial_period_length => '',
          :loan_type => 'Any',
          :lender => 'Any'
        }
      end

      it "should not create a search" do
        expect {
          post 'create', :search => @fail_attr
        }.to change(Search, :count).by(0)
      end

      it "should render the new template" do
        post 'create', :search => @fail_attr
        response.should render_template 'new'
      end

#      I've no idea why this fails
      it "should have error messages" do
        post 'create', :search => @fail_attr
        response.should have_selector('div#search_error')
      end
    end
  end
end
