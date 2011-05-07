class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.float :initial_rate
      t.string :lender
      t.string :loan_type
      t.integer :min_ltv
      t.integer :max_ltv
      t.integer :initial_period_length
      t.float :rolls_to
      t.integer :max_princ
      t.integer :min_princ

      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
