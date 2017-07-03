class AddVisitToProject < ActiveRecord::Migration
  def change
    add_column :projects, :visit, :string, :default => ""
  end
end
