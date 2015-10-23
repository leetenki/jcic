class AddJapanCompanyTypeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :group_japan_company, :string, :default => "random"
    add_column :traders, :individual_japan_company, :string, :default => "random"
  end
end
