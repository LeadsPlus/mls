class AddDaftIdentifierToPropertyType < ActiveRecord::Migration
  def change
    add_column :property_types, :daft_identifier, :string
  end
end
