class RemoveCountyNameFromHouses < ActiveRecord::Migration
  def change
    remove_column :houses, :county
  end
end
