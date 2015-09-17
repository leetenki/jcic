class CreateTraders < ActiveRecord::Migration
  def change
    create_table :traders do |t|
      t.string :account
      t.string :password_backup
      t.string :password_digest

      t.string :company_name
      t.string :person_name
      t.string :telephone
      t.string :fax
      t.string :qq
      t.string :bank
      t.string :address
      t.string :email
      t.timestamps null: false
      t.index :account, :unique => true
    end
  end
end
