class CreateDisbursements < ActiveRecord::Migration[6.1]
  def change
    create_table :disbursements do |t|
      t.belongs_to :merchant, null: false, index: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.decimal :fee, precision: 8, scale: 2, null: false
      t.date :disbursement_date, null: false

      t.timestamps
    end
  end
end
