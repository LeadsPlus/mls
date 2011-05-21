class ChangeCountyToLocation < ActiveRecord::Migration
  def self.up
    rename_column :searches, :county, :location
  end

  def self.down
    rename_column :searches, :location, :county
  end
end
