require 'spec_helper'

describe "rates/index.html.haml" do
  before(:each) do
    assign(:rates, [
      stub_model(Rate,
        :initial_rate => 1.5,
        :lender => "Lender",
        :type => "Type",
        :min_depos => 1,
        :initial_period_length => 1,
        :svr => 1.5,
        :max_princ => 1,
        :min_princ => 1
      ),
      stub_model(Rate,
        :initial_rate => 1.5,
        :lender => "Lender",
        :type => "Type",
        :min_depos => 1,
        :initial_period_length => 1,
        :svr => 1.5,
        :max_princ => 1,
        :min_princ => 1
      )
    ])
  end

  it "renders a list of rates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lender".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
