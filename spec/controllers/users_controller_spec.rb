require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = Factory :user
      sign_in @user
    end

    it "should be successful" do
      get 'show', :id => @user.id
      response.should be_success
    end

    it "should show a user" do
      get 'show', :id => @user.id
      response.should have_selector("h1", :content => @user.email)
    end

    it "should not be able to view the profile of another user"
    it "should allow access to admins"
  end

  describe "GET 'index'" do
    before(:each) do
      @user = Factory :user
      @user2 = Factory :user, :email => Factory.next(:email)
      sign_in @user
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should list users" do
      get 'index'
      response.should have_selector("td", :content => @user2.email)
    end

    it "should deny access to non admin users"
    it "should allow access when user is admin"
  end
end
