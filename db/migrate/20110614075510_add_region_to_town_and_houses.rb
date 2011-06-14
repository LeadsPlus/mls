class AddRegionToTownAndHouses < ActiveRecord::Migration
  def change
    add_column :houses, :region_name, :string
    add_column :towns, :region_name, :string
  end
end
