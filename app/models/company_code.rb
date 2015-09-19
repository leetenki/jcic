class CompanyCode < ActiveRecord::Base
  validates :name, :presence => true
  validates :code, :presence => true
  validates :locate, :presence => true
  validates :status, :presence => true, :inclusion => {:in => ["working", "stopped"]}
end
