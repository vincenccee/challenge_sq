class CreateMinimumMonthlyCharges < ActiveRecord::Migration[6.1]
  def up
    create_table :minimum_monthly_charges do |t|
      t.belongs_to :merchant, null: false, foreign_key: true
      t.decimal :amount, null: false
      t.integer :year, null: false
      t.integer :month, null: false

      t.timestamps
    end
  end

  def down
    drop_table :minimum_monthly_charges
  end
end
