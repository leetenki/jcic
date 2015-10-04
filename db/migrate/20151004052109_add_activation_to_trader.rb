class AddActivationToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :activation, :boolean, :default => true
  end
end
