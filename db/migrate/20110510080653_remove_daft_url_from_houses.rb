class RemoveDaftUrlFromHouses < ActiveRecord::Migration
  def self.up
    remove_column :houses, :daft_url
  end

  def self.down
    add_column :houses, :daft_url, :string
  end
end
