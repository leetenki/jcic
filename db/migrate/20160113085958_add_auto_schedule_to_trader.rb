class AddAutoScheduleToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :auto_schedule, :string, :default => "inactive"
  end
end
