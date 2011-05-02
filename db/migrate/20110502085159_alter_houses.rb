class AlterHouses < ActiveRecord::Migration
  def self.up
    rename_column :houses, :address, :street
    add_column :houses, :number, :integer
    add_column :houses, :county, :string
    add_column :houses, :town, :string
    add_column :houses, :image_url, :string
    add_column :houses, :description, :text
    add_column :houses, :title, :string
  end

  def self.down
    rename_column :houses, :street, :address
    remove_column :houses, :number
    remove_column :houses, :county
    remove_column :houses, :town
    remove_column :houses, :image_url
    remove_column :houses, :description
    remove_column :houses, :title
  end
end
