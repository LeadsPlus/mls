require 'spec_helper'

describe "Houses" do
  describe "GET show" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit houses_path
      page.status_code.should be(200)
    end
  end
end
