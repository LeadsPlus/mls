require 'spec_helper'

describe "houses/index.html.haml" do
  before(:each) do
    assign(:houses, [
      stub_model(House,
        :address => "Address",
        :price => 1,
        :bedrooms => 1
      ),
      stub_model(House,
        :address => "Address",
        :price => 1,
        :bedrooms => 1
      )
    ])
  end

  it "renders a list of houses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
