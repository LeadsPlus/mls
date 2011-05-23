require 'spec_helper'

describe "Searches" do
  before(:each) do
    @rate = Factory :rate
    @house = Factory :house
    @default_search = Factory :search, :id => 1
  end

  describe "from the root path" do
    it "should create a search with the default values" do
      visit root_path
      expect {
        click_button "Search"
      }.to change(Search, :count).by(1)
    end

    describe "results content" do
      it "should show the matching houses" do
        visit root_path
        click_button "Search"
        page.should have_content(@house.daft_title)
      end

      it "should show the rate we're using" do
        visit root_path
        page.should have_selector("tr", class: "rate")
      end

      it "should show the actual monthly payment required" do
        @search = Search.find 2
        visit root_path
        click_button "Search"
        @house.calc_payment_required_assuming(@rate, @search.term, @search.deposit)
        page.should have_content(@house.payment_required)
      end
    end
  end
end