class RemoveIndexFromClient < ActiveRecord::Migration
  def change
    remove_index :clients, [:project_id, :passport_no]
  end
end
