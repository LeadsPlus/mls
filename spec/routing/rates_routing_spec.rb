require "spec_helper"

describe RatesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/rates" }.should route_to(:controller => "rates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/rates/new" }.should route_to(:controller => "rates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/rates/1" }.should route_to(:controller => "rates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/rates/1/edit" }.should route_to(:controller => "rates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/rates" }.should route_to(:controller => "rates", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/rates/1" }.should route_to(:controller => "rates", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/rates/1" }.should route_to(:controller => "rates", :action => "destroy", :id => "1")
    end

  end
end
