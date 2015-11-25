class AddEditableMinToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :editable_min, :integer, :default => 5
  end
end
