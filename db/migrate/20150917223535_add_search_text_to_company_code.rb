class AddSearchTextToCompanyCode < ActiveRecord::Migration
  def change
    add_column :company_codes, :search_text, :string
  end
end
