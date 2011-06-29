class ChangeSearchPropertyTypes < ActiveRecord::Migration
  def change
    rename_column :searches, :prop_type_uids, :property_type_ids
  end
end
