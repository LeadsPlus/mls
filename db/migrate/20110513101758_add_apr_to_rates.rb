class AddAprToRates < ActiveRecord::Migration
  def self.up
    add_column :rates, :twenty_year_apr, :float
  end

  def self.down
    remove_column :rates, :twenty_year_apr
  end
end
