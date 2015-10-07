class AddSystemCodeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :system_code, :string
    add_column :projects, :pdf, :string
  end
end
