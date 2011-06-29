class CreatePropertyTypes < ActiveRecord::Migration
  def change
    create_table :property_types do |t|
      t.string :name
      t.string :uid

      t.timestamps
    end
    add_index :property_types, :uid, :unique => true
  end
end
