class RemoveIndexFromSchedule < ActiveRecord::Migration
  def change
    remove_index :schedules, :column => [:project_id, :date], :name => "unique_schedule"
    remove_index :schedules, :column => [:project_id, :date], :name => "unique_schedule2"
  end
end
