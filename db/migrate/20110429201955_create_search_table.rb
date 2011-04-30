class CreateSearchTable < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :payment
      t.integer :deposit

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
