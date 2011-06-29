require 'spec_helper'

describe PropertyType do
  before :each do
    @valid_attr = { name: "Detached House", uid: "Detached" }
  end

  it "should create a new type give valid attributes" do
    PropertyType.create! @valid_attr
  end

  it "should require a UID" do
    PropertyType.new(@valid_attr.merge(uid: "")).should_not be_valid
  end

  it "should require a name" do
    PropertyType.new(@valid_attr.merge(name: "")).should_not be_valid
  end

  it "should require a unique UID" do
    PropertyType.create! @valid_attr
    PropertyType.new(@valid_attr).should_not be_valid
  end

#  describe "associations" do
#    before(:each) do
#      @search = Search.create @valid_attr
#    end
#
#    it "should have a rate attribute" do
#      @search.should respond_to :rate
#    end
#
#    it "should retrieve the associated rate" do
#      @search.rate.should == @rate
#    end
#
#    it "should have a usage association" do
#      @search.should respond_to :usage
#    end
#
#    it "should retrieve the associated usage" do
#      @search.usage.should == @usage
#    end
#  end

  describe "checkbox_options method"

  describe "reset method" do
    before(:each) do
      PropertyType.create! @valid_attr
    end

    it "should delete all searches" do
      expect {
        PropertyType.reset
      }.to change(PropertyType, :count).to(0)
    end

    it "should reset the auto increment column" do
      PropertyType.reset
      type = PropertyType.create! @valid_attr
      type.id.should == 1
    end
  end
end
