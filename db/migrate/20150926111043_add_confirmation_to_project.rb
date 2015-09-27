class AddConfirmationToProject < ActiveRecord::Migration
  def change
    add_column :projects, :confirmation, :string, :default => "unconfirmed"
  end
end
