require 'spec_helper'

describe RatesController do
  render_views
  
  describe "GET index" do
    before(:each) do
      @rate = Factory :rate
    end

    it "should be a success" do
      get 'index'
      response.should be_success
    end

    it "should show the houses" do
      get 'index'
      response.should have_selector('tr.rate')
    end
  end

  describe "GET show" do
    before(:each) do
      @rate = Factory :rate
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'show', :id => @rate
      response.should be_success
    end

    it "should show the house's details" do
      get 'show', :id => @rate
      response.should have_selector('p.lender', :content => @rate.lender)
    end
  end

  describe "GET new" do
    before(:each) do
      @rate = Factory :rate
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'new'
      response.should be_success
    end

    it "should have a form to fill in the rate's details" do
      get 'new'
      response.should have_selector('form#new_rate')
    end
  end

  describe "GET edit" do
    before(:each) do
      @rate = Factory :rate
      @user = Factory :user
      sign_in @user
    end

    it "should be a success" do
      get 'edit', :id => @rate
      response.should be_success
    end

    it "should have a form to edit the house's details" do
      get 'edit', :id => @rate
      response.should have_selector "form"
    end

    it "should be prefilled with the rates details" do
      get 'edit', :id => @rate
      response.should have_selector "input#rate_initial_rate", :value => @rate.initial_rate.to_s
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
          :initial_rate => 3.0,
          :twenty_year_apr => 3.05,
          :lender => 'Bank of Ireland',
          :loan_type => 'Variable Rate',
          :min_ltv => 50,
          :max_ltv => 79,
          :max_princ => 500_000
        }
      end

      it "should add a rate to the DB" do
        lambda {
          post 'create', :rate => @valid_attr
        }.should change(Rate, :count).by(1)
      end

      it "redirects to the created rate" do
        post 'create', :rate => @valid_attr
        response.should redirect_to(rate_url(assigns :rate))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @invalid_attr = {
          :initial_rate => "",
          :twenty_year_apr => '',
          :lender => '',
          :loan_type => '',
          :min_ltv => '',
          :max_ltv => '',
          :max_princ => ''
        }
      end

      it "should not create a DB record" do
        expect {
          post 'create', :rate => @invalid_attr
        }.to change(Rate, :count).by(0)
      end

      it "should re-render the 'new' template" do
        post "create", :rate => @invalid_attr
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @rate = Factory :rate
      @user = Factory :user
      sign_in @user
    end
    
    describe "with valid params" do
      before(:each) do
        @update_attr = {
          :initial_rate => 3.0,
          :twenty_year_apr => 4.23,
          :lender => 'AIB',
          :loan_type => 'Variable Rate',
          :min_ltv => 50,
          :max_ltv => 79,
          :max_princ => 500_000
        }
      end

      it "updates the requested house" do
        put 'update', :id => @rate, :rate => @update_attr

        @rate.reload
        @rate.initial_rate.should  == @update_attr[:initial_rate]
        @rate.lender.should == @update_attr[:lender]
      end

      it "redirects to the rate" do
        put 'update', :id => @rate, :rate => @update_attr
        response.should redirect_to(rate_path(@rate))
      end
    end

    describe "with invalid params" do
      before(:each) do
        @invalid_attr = {
          :initial_rate => '',
          :twenty_year_apr => '',
          :lender => '',
          :loan_type => 'Variable Rate',
          :min_ltv => 50,
          :max_ltv => 79,
          :max_princ => 500_000
        }
      end

      it "should re-render the edit template" do
        put 'update', :id => @rate, :rate => @invalid_attr
        response.should render_template('edit')
      end
    end
  end

#  1. Action name must be supplied as a string. Not a path
#  2. You don't need the :js => true
#  3. You can leave off the .id from @rate.id
  describe "DELETE destroy" do
    before(:each) do
      @rate = Factory :rate
      @user = Factory :user
      sign_in @user
    end

    it "destroys the requested rate" do
      expect {
        delete 'destroy', :id => @rate
      }.to change(Rate, :count).by(-1)
    end

    it "redirects to the rates list" do
      delete 'destroy', :id => @rate
      response.should redirect_to(rates_path)
    end
  end
end
