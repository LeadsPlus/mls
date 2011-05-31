class AddBedsAndBathsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :bedrooms, :string
    add_column :searches, :bathrooms, :string
  end
end
