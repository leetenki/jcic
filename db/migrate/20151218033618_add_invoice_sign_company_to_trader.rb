class AddInvoiceSignCompanyToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :invoice_sign_company, :string, :default => "jcic"
  end
end
