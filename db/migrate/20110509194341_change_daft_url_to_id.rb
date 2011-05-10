class ChangeDaftUrlToId < ActiveRecord::Migration
  def self.up
    add_column :houses, :daft_id, :integer
    add_index :houses, :daft_id
  end

  def self.down
    remove_index :houses, :daft_id
    remove_column :houses, :daft_id
  end
end
