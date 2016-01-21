class AddChinaJapanRateToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :china_japan_rate, :float, :default => 20.0
  end
end
