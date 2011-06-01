class AddPropTypeUidsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :prop_type_uids, :string
    add_column :houses, :property_type_uid, :string
  end
end
