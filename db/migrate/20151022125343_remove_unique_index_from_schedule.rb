class RemoveUniqueIndexFromSchedule < ActiveRecord::Migration
  def change
    remove_index :schedules, :column => [:project_id, :date], :name => "unique_schedule"
  end
end
