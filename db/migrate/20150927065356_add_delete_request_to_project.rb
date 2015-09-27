class AddDeleteRequestToProject < ActiveRecord::Migration
  def change
    add_column :projects, :delete_request, :boolean, :default => false
  end
end
