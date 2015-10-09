class AddValidationModeToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :validation_mode, :string, :default => "easy"
  end
end
