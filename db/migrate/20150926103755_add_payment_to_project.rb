class AddPaymentToProject < ActiveRecord::Migration
  def change
    add_column :projects, :payment, :string, :default => "unpaid"
  end
end
