# well I figured out the problem with the 'No response yet. Request a page first' error
# it seems it is caused by incompatibility between webrat and capybara: http://stackoverflow.com/questions/6026173/using-both-webrat-and-capybara-together
# of course, solving this means that I need to stop using webrat, which means I need to figure out how to do controller
# tests with it. Also I haven't figured out how to make it load the css

require 'spec_helper'

describe "Searches" do
  before(:each) do
    @rate = Factory :rate
    @house = Factory :house, :town_id => 2367, :county_id => 30
    @default_search = Factory :search, :id => 1, :rate => @rate
  end

    it "should use search ID 1 as the home page" do
      visit root_path
#      have_selector only works when you provide a CSS selector.
#      ie. the below would not work if I removed the 'input#'
      page.should have_selector('input#search_min_payment', value: @default_search.min_payment)
      page.should have_selector('input#search_max_payment', value: @default_search.max_payment)
      page.should have_selector('input#search_deposit', value: @default_search.deposit)
    end

  describe "pagination links" do
    before(:each) do
      @houses = []
      20.times do |i|
        @houses << Factory(:house)
      end
    end

#    locations are not appearing on the save_open_page
#    probably causing problems
    it "should have links to the next page" do
      visit root_path
      save_and_open_page
      page.should have_link '2'
      page.should have_link 'Next'
    end

    it "should retrieve the next page of results" do

    end
  end
end