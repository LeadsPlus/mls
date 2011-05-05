require 'spec_helper'

describe SearchesController do
  render_views

  before(:each) do
    @search = Factory :search
  end

  describe "GET index" do
    it "should be success" do
      visit searches_path
      response.should be_success
    end

    it "should list searches" do
      visit searches_path
      page.should have_selector('tr#search-1')
    end
  end

  describe "GET show" do
    it "should be success" do
      visit searches_path(@search.id)
      response.should be_success
    end

    describe "when there are matches" do
      it "should list matches"
    end

    describe "when there are no matches" do
      
    end
  end
end
