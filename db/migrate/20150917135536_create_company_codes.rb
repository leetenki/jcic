class CreateCompanyCodes < ActiveRecord::Migration
  def change
    create_table :company_codes do |t|
      t.string :name
      t.string :code
      t.string :locate
      t.string :status
      t.string :memo
      t.string :address

      t.timestamps null: false
    end
  end
end
