class AddAuthorityToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :authority, :string, :default => "self"
  end
end
