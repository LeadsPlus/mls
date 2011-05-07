class AddIndexToHouses < ActiveRecord::Migration
  def self.up
    add_index :houses, :price
    add_index :houses, :county
  end

  def self.down
    remove_index :houses, :county
    remove_index :houses, :price
  end
end
