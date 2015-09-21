class AddIndexToProject < ActiveRecord::Migration
  def change
    add_index :projects, [:trader_id, :china_company_code, :visa_type, :total_people, :representative_name_english, :date_arrival, :date_leaving], :unique => true, :name => :unique_project_condition
  end
end
