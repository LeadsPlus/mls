class MatchHousesToDaft < ActiveRecord::Migration
  def self.up
    remove_column :houses, :number
    remove_column :houses, :town
    remove_column :houses, :street
    remove_column :houses, :bedrooms
    add_column :houses, :daft_url, :string
  end

  def self.down
    remove_column :houses, :daft_url
    add_column :houses, :number, :integer
    add_column :houses, :town, :string
    add_column :houses, :street, :string
    add_column :houses, :bedrooms, :integer
  end
end
