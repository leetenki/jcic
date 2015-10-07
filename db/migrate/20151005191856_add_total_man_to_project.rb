class AddTotalManToProject < ActiveRecord::Migration
  def change
    add_column :projects, :total_man, :integer, :default => 0
    add_column :projects, :total_woman, :integer, :default => 0
  end
end
