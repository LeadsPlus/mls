require 'spec_helper'

describe "Searches" do
#  how do I test when there's no data in the test DB???
#  I guess I need to use fixtures
  it "should work with the default values" do
    visit root_path
    save_and_open_page
    click_button "Search"

    page.should have_selector("5 Rosscah View")
  end
end