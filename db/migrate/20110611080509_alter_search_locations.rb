class AlterSearchLocations < ActiveRecord::Migration
  def change
    rename_column :searches, :location, :locations
    change_column :searches, :locations, :string, :limit => 400
  end
end
