class AddHasFullScheduleToScheduleToProject < ActiveRecord::Migration
  def change
    add_column :projects, :has_full_schedule, :boolean, :default => false
  end
end
