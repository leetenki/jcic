class AddIndexToSchedule < ActiveRecord::Migration
  def change
    add_index :schedules, [:project_id, :date], :unique => true, :name => :unique_schedule
  end
end
