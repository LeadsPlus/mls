class CreateHouseTypeAssociation < ActiveRecord::Migration
  def change
    remove_column :houses, :property_type
    add_column :houses, :property_type_id, :integer
  end
end
