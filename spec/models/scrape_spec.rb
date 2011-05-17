require 'spec_helper'

describe Scrape do
  describe "delete_houses_in_county method" do
    it "should delete the houses in the county" do
      @house = Factory :house
#      why am I passing in an ID here, why not a county name?
      expect {
        Scrape.new.delete_houses_in_county(4)
      }.to change(House, :count).by(-1)
    end
  end

  describe "delay" do
    it "should occur for visit_houses_in_county method" do
      expect {
        Scrape.new.visit_houses_in_county
      }.to change(Delayed::Job, :count).by(1)
    end

    it "should occur for visit_houses_in_county method" do
      expect {
        Scrape.new.visit_houses_in_county
      }.to change(Delayed::Job, :count).by(1)
    end
  end
end