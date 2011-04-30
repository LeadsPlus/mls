require 'spec_helper'

describe "houses/new.html.erb" do
  before(:each) do
    assign(:house, stub_model(House,
      :address => "MyString",
      :price => 1,
      :bedrooms => 1
    ).as_new_record)
  end

  it "renders new house form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => houses_path, :method => "post" do
      assert_select "input#house_address", :name => "house[address]"
      assert_select "input#house_price", :name => "house[price]"
      assert_select "input#house_bedrooms", :name => "house[bedrooms]"
    end
  end
end
