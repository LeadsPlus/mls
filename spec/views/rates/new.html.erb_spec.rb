require 'spec_helper'

describe "rates/new.html.erb" do
  before(:each) do
    assign(:rate, stub_model(Rate,
      :initial_rate => 1.5,
      :lender => "MyString",
      :type => "MyString",
      :min_depos => 1,
      :initial_period_length => 1,
      :svr => 1.5,
      :max_princ => 1,
      :min_princ => 1
    ).as_new_record)
  end

  it "renders new rate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rates_path, :method => "post" do
      assert_select "input#rate_initial_rate", :name => "rate[initial_rate]"
      assert_select "input#rate_lender", :name => "rate[lender]"
      assert_select "input#rate_type", :name => "rate[type]"
      assert_select "input#rate_min_depos", :name => "rate[min_depos]"
      assert_select "input#rate_initial_period_length", :name => "rate[initial_period_length]"
      assert_select "input#rate_svr", :name => "rate[svr]"
      assert_select "input#rate_max_princ", :name => "rate[max_princ]"
      assert_select "input#rate_min_princ", :name => "rate[min_princ]"
    end
  end
end
