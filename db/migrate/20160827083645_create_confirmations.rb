class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.references :trader, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
