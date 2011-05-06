require 'spec_helper'

# these tests are not working properly. Don't trust them.

describe SearchesController do
  render_views

  describe "GET index" do
    before(:each) do
      @search = Factory :search
    end

    it "should be success" do
      get 'index' do
        response.should be_success
      end
    end

    it "should list searches" do
      get 'index'
      page.should have_selector('tr#search-1')
    end
  end

  describe "GET show" do
    before(:each) do
      @search = Factory :search
    end
    
    it "should be success" do
      get'show', :id => @search
      response.should be_success
    end

    describe "when there are matches" do
      before(:each) do
        @match = Factory :house
      end

      it "should list matches" do
        visit search_path(@search.id)
        page.should have_selector('tr.house')
      end

      it "should show the content of the matches houses" do
         visit search_path(@search.id)
        page.should have_content('This is the title of a house')
      end
    end

    describe "when there are no matches" do
      it "should say so" do
        visit search_path(@search.id)
        page.should have_content('sorry but no houses')
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
          :county_id => 5
        }
      end

      it "should create a search" do
        expect {
          post 'create', :search => @attr
        }.to change(Search, :count).by(1)
      end

      it "should redirect to the search show page" do
        post 'create', :search => @attr
        current_path.should == search_path(assigns :search)
      end
    end

    describe "failure" do
      before(:each) do
        @fail_attr = {
          :deposit => '',
          :min_payment => -234,
          :max_payment => nil,
          :term => nil,
          :county_id => nil
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
        page.should have_selector('div#search_error')
      end
    end
  end
end
