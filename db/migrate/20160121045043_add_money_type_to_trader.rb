class AddMoneyTypeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :money_type, :string, :default => "japan"
  end
end
