class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :project, index: true
      t.date :date
      t.text :plan
      t.text :hotel

      t.timestamps null: false
      t.index [:project_id, :date]
    end
  end
end
