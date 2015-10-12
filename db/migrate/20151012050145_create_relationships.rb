class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :master, index: true
      t.references :slave, index: true

      t.timestamps null: false
      t.index [:master_id, :slave_id], :unique => true
    end
  end
end
