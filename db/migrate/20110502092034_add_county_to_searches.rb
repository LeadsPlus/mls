class AddCountyToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :county, :string
  end

  def self.down
    remove_column :searches, :county
  end
end
