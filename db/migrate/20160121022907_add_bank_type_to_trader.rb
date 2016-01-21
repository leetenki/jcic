class AddBankTypeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :bank_type, :string, :default => "japan"
  end
end
