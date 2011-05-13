require 'spec_helper'

describe "Searches" do
  before(:each) do
    Factory :rate
    Factory :search, :id => 1
  end
  
  describe "visiting the user aggreement" do
    it "should work" do
      visit root_path
      click_link "User Agreement"

      page.current_path.should == user_agreement_path
      page.should have_content("AGREEMENT BETWEEN USER AND HowMuchHouse.net")
    end

    it "should have link to get off holy wall of text" do
      visit user_agreement_path
      click_link "Home"
      page.current_path.should == root_path
    end
  end
end