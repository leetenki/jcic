class AddExtraToProject < ActiveRecord::Migration
  def change
    add_column :projects, :extra, :string, :default => ""
  end
end
