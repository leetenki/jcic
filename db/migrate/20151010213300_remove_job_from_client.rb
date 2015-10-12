class RemoveJobFromClient < ActiveRecord::Migration
  def change
    remove_column :clients, :job
    add_column :clients, :job, :string
  end
end
