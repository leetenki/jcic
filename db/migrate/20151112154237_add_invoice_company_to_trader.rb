class AddInvoiceCompanyToTrader < ActiveRecord::Migration
  def change
    add_column :traders, :invoice_company, :string, :default => "jcic"
  end
end
