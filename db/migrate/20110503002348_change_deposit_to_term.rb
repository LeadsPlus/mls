class ChangeDepositToTerm < ActiveRecord::Migration
  def self.up
    rename_column :searches, :deposit, :term
  end

  def self.down
    rename_column :searches, :term, :deposit
  end
end
