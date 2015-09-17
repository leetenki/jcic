class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :trader, index: true
      t.string :china_company_name
      t.string :china_company_code
      t.string :visa_type
      t.integer :total_people
      t.string :representative_name_english
      t.string :representative_name_chinese
      t.string :date_arrival
      t.string :date_leaving
      t.string :status, :default => "uncommitted"

      t.timestamps null: false
      t.index [:trader_id, :created_at]
    end
  end
end
