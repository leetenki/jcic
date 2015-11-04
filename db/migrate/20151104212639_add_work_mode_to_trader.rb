class AddWorkModeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :work_mode, :string, :default => "auto"
  end
end
