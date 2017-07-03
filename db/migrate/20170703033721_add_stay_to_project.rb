class AddStayToProject < ActiveRecord::Migration
  def change
    add_column :projects, :stay, :string, :default => ""
  end
end
