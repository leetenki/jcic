class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :project, index: true, foreign_key: true
      t.string :name_chinese
      t.string :name_english
      t.string :gender
      t.string :hometown
      t.date :birthday
      t.string :passport_no

      t.timestamps null: false
      t.index [:project_id, :passport_no], :unique => true
    end
  end
end
