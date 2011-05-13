require 'spec_helper'

describe HousesController do
  render_views
  
  describe "GET index" do
    before(:each) do
      @house = Factory :house
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'index'
      response.should be_success
    end

    it "should show the houses" do
      get 'index'
      response.should have_selector('tr.house')
    end
  end

  describe "GET show" do
    before(:each) do
      @house = Factory :house
    end

    it "should be a success" do
      get 'show', :id => @house
      response.should be_success
    end

    it "should show the house's details" do
      get 'show', :id => @house
      response.should have_selector('h2', :content => @house.title)
    end
  end

  describe "GET new" do
    before(:each) do
      @house = Factory :house
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'new'
      response.should be_success
    end

    it "should have a form to fill in the house's details" do
      get 'new'
      response.should have_selector('form#new_house')
    end
  end

  describe "GET edit" do
    before(:each) do
      @house = Factory :house
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'edit', :id => @house
      response.should be_success
    end

    it "should have a form to edit the house's details" do
      get 'edit', :id => @house
      response.should have_selector "form"
    end

    it "should be prefilled with the houses details" do
      get 'edit', :id => @house
      response.should have_selector "input#house_title", :value => @house.title
    end
  end

  describe "POST create" do
    before(:each) do
      @user = Factory :user
      sign_in @user
    end

    describe "with valid params" do
      before(:each) do
        @valid_attr = {
          :title => "This is the title of a house",
          :description => "This is the description of a house",
          :image_url => 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
          :county => "Wicklow",
          :price => 200_000,
          :daft_id => 8384834
        }
      end

      it "should add a house to the DB" do
        lambda {
          post 'create', :house => @valid_attr
        }.should change(House, :count).by(1)
      end

      it "redirects to the created house" do
        post 'create', :house => @valid_attr
        response.should redirect_to(house_url(assigns :house))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @invalid_attr = {
          :title => "",
          :description => "",
          :image_url => '',
          :price => nil,
          :county => ''
        }
      end

      it "should not create a DB record" do
        expect {
          post 'create', :house => @invalid_attr
        }.to change(House, :count).by(0)
      end

      it "should re-render the 'new' template" do
        post "create", :house => @invalid_attr
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @house = Factory :house
      @user = Factory :user
      sign_in @user
    end
    
    describe "with valid params" do
      before(:each) do
        @update_attr = {
          :title => "This is the new title of a house",
          :description => "This is a different description of a house",
          :image_url => 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
          :county => "Wicklow",
          :price => 200_000,
          :daft_id => 43849
        }
      end

      it "updates the requested house" do
        put 'update', :id => @house, :house => @update_attr

        @house.reload
        @house.title.should  == @update_attr[:title]
        @house.description.should == @update_attr[:description]
      end

      it "redirects to the house" do
        put 'update', :id => @house, :house => @update_attr
        response.should redirect_to(house_path(@house))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @invalid_attr = {
          :title => "",
          :description => "",
          :image_url => '',
          :price => nil,
          :county => ''
        }
      end

      it "should re-render the edit template" do
        put 'update', :id => @house, :house => @invalid_attr
        response.should render_template('edit')
      end
    end
  end

#  1. Action name must be supplied as a string. Not a path
#  2. You don't need the :js => true
#  3. You can leave off the .id from @house.id
  describe "DELETE destroy" do
    before(:each) do
      @house = Factory :house
      @user = Factory :user
      sign_in @user
    end

    it "destroys the requested house" do
      expect {
        delete 'destroy', :id => @house
      }.to change(House, :count).by(-1)
    end

    it "redirects to the houses list" do
      delete 'destroy', :id => @house
      response.should redirect_to(houses_path)
    end
  end
end
