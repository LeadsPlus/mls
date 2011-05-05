class ChangeCountiesToCountyId < ActiveRecord::Migration
  def self.up
    remove_column :searches, :county
    add_column :searches, :county_id, :integer

    remove_column :houses, :county
    add_column :houses, :county_id, :integer
  end

  def self.down
    remove_column :searches, :county_id
    add_column :searches, :county, :string

    remove_column :houses, :county_id
    add_column :houses, :county, :string
  end
end
