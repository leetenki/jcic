class AddJapanCompanyToProject < ActiveRecord::Migration
  def change
    add_column :projects, :japan_company, :string, :default => "jcic"
  end
end
