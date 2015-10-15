class RemoveIndexFromProject < ActiveRecord::Migration
  def change
    remove_index :projects, :name => :unique_project_condition
  end
end
