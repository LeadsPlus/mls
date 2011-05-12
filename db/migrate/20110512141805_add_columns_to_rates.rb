class AddColumnsToRates < ActiveRecord::Migration
  def self.up
    add_column :rates, :min_deposit, :integer
    add_column :rates, :max_deposit, :integer
  end

  def self.down
    remove_column :rates, :max_deposit
    remove_column :rates, :min_deposit
  end
end
