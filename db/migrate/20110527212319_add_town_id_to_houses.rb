class AddTownIdToHouses < ActiveRecord::Migration
  def change
    add_column :houses, :town_id, :integer
  end
end
