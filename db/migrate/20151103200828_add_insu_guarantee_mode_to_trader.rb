class AddInsuGuaranteeModeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :guarantee_mode, :string, :default => "normal"
  end
end
