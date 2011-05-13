require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'user_agreement'" do
    it "should be successful" do
      get 'user_agreement'
      response.should be_success
    end
  end

end
