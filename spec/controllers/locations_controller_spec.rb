require 'spec_helper'

describe LocationsController do
  
  # These need to be JS enabled requests since
  # this action doesn't respond to html reuests
  describe "'GET' index" do
    it "should be successful" do
      get 'index', name: 'Dublin'
      response.should be_success
    end

    it "should retrieve a county when user enters an exact match county name"
    it "should return one town when user enters an exact match town name"
  end
end
