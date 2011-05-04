class AddMinPaymentToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :min_payment, :integer
    rename_column :searches, :payment, :max_payment
  end

  def self.down
    remove_column :searches, :min_payment
    rename_column :searches, :max_payment, :payment
  end
end
