require 'spec_helper'

describe "Searches" do
  before(:each) do
    Factory :rate
    Factory :house
    Factory :search, :id => 1
  end

  describe "from the root path" do
    it "should create a search with the default values" do
      visit root_path
      expect {
        click_button "Search"
      }.to change(Search, :count).by(1)
    end

    describe "results content" do
      before(:each) do
        visit root_path
        click_button "Search"
      end

      it "should show the matching houses" do
        page.should have_content("This is the title of a house")
      end

      it "should show the rate we're using" do
        page.should have_selector("tr.rate")
      end
    end
  end
end