class AddPriceToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :indivisual_price, :integer, :default => 500
    add_column :traders, :group_price_indivisual, :integer, :default => 0
    add_column :traders, :group_price_1_10, :integer, :default => 0
    add_column :traders, :group_price_11_20, :integer, :default => 3000
    add_column :traders, :group_price_21_30, :intger, :default => 6000
    add_column :traders, :group_price_31_40, :integer, :default => 9000
    add_column :traders, :year_3_price, :integer, :default => 1000
    add_column :traders, :year_5_price, :integer, :default => 1000
    add_column :traders, :other_price, :integer, :default => 5000
  end
end
