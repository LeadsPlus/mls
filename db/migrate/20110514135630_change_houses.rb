class ChangeHouses < ActiveRecord::Migration
  def self.up
    rename_column :houses, :title, :daft_title
    add_column :houses, :bedrooms, :integer
    add_column :houses, :bathrooms, :integer
    add_column :houses, :daft_date_created, :date
    add_column :houses, :address, :string
    add_column :houses, :property_type, :string
  end

  def self.down
    remove_column :houses, :property_type
    remove_column :houses, :address
    remove_column :houses, :daft_date_created
    remove_column :houses, :bathrooms
    remove_column :houses, :bedrooms
    rename_column :houses, :daft_title, :title
  end
end
