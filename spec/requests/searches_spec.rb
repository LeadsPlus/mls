require 'spec_helper'

describe "Searches" do
  before(:each) do
    Factory :rate
    Factory :house, :county => "Fermanagh"
  end

  describe "from the root path" do
    it "should work with the default values" do
      visit root_path
      click_button "Search"

      page.should have_selector "tr.house"
    end
  end
end