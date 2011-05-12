class AddResultsToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :max_price, :integer
    add_column :searches, :min_price, :integer
  end

  def self.down
    remove_column :searches, :min_price
    remove_column :searches, :max_price
  end
end
