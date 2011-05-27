class CreateTowns < ActiveRecord::Migration
  def change
    create_table :towns do |t|
      t.integer :county_id
      t.string :name
      t.string :daft_id

      t.timestamps
    end
  end
end
