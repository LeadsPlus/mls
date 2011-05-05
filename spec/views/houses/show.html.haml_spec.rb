require 'spec_helper'

describe "houses/show.html.haml" do
  before(:each) do
    @house = assign(:house, stub_model(House,
      :address => "Address",
      :price => 1,
      :bedrooms => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
