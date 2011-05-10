class AddMortgageOptionsToSearch < ActiveRecord::Migration
  def self.up
    add_column :searches, :loan_type, :string
    add_column :searches, :initial_period_length, :integer
    add_column :searches, :lender, :string
  end

  def self.down
    remove_column :searches, :lender
    remove_column :searches, :initial_period_length
    remove_column :searches, :loan_type
  end
end
