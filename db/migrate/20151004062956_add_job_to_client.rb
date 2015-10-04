class AddJobToClient < ActiveRecord::Migration
  def change
    add_column :clients, :job, :string, :default => "科员"
  end
end
