class RemoveRegionNameFromTowns < ActiveRecord::Migration
  def change
    remove_column :towns, :region_name
  end
end
