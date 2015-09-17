class Project < ActiveRecord::Base
  #relationships
  belongs_to :trader

  #validation
  validates :china_company_name, :presence => true
  validates :china_company_code, :presence => true
  validates :visa_type, :presence => true
  validates :total_people, :presence => true
  validates :representative_name_english, :presence => true
  validates :representative_name_chinese, :presence => true
  validates :date_arrival, :presence => true
  validates :date_leaving, :presence => true
  validates :status, :presence => true
end
