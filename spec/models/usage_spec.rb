require 'spec_helper'

describe Usage do
  before(:each) do
    @valid_attr = {
      ip_address: '127.343.232.345',
      user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.91 Safari/534.30'
    }
  end

  it "should create a new record given valid attributes" do
    Usage.create!(@valid_attr)
  end

  it "should record an identifier hash before saving" do
    @usage = Usage.create(@valid_attr)
    @usage.identifier.should == '4356a29462afbc96a87c08a69b1e64de'
  end

  describe "search associations" do
    before(:each) do
      @rate = Factory :rate
      @usage = Usage.create(@valid_attr)
      @search = Factory :search, :usage => @usage
      @second_search = Factory :search, :usage => @usage
    end

    it "should have a searches attribute" do
      @usage.should respond_to(:searches)
    end

    it "should retrieve the associated searches" do
      @usage.searches.should == [@search, @second_search]
    end
  end

  describe "reset method" do
    before(:each) do
      Usage.create @valid_attr
    end

    it "should delete all searches" do
      expect {
        Usage.reset
      }.to change(Usage, :count).to(0)
    end

    it "should reset the auto increment column" do
      Usage.reset
      usage = Usage.create! @valid_attr
      usage.id.should == 1
    end
  end
end

# == Schema Information
#
# Table name: usages
#
#  id         :integer         not null, primary key
#  identifier :string(32)
#  user_agent :string(255)
#  ip_address :string(255)
#  created_at :datetime
#  updated_at :datetime
#

