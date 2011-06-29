class RemovePropertyTypeUidColumn < ActiveRecord::Migration
  def change
    remove_column :houses, :property_type_uid
  end
end
