class RafactorHousesAndTowns < ActiveRecord::Migration
  def change
    remove_column :towns, :county_id
    add_column :towns, :county, :string
    remove_column :houses, :daft_date_entered
    add_column :houses, :last_scrape, :integer
  end
end
