class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true
      t.string :channel, null: false
      t.boolean :anonymous, default: false, null: false

      t.timestamps
    end
  end
end
