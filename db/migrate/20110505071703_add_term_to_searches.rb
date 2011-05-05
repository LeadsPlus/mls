class AddTermToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :term, :integer
  end

  def self.down
    remove_column :searches, :term
  end
end
