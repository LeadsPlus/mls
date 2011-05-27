class AddCountyIdToHouses < ActiveRecord::Migration
  def change
    add_column :houses, :county_id, :integer
  end
end
