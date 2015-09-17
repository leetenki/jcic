class Trader < ActiveRecord::Base
  #relationship
  has_many :projects

  #before_save
  before_save { self.email = email.downcase }

  #validation name, email, password(password + password_confirmation -> password_digest)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :company_name, :presence => true
  validates :person_name, :presence => true
  validates :account, :presence => true
  validates :password_backup, :presence => true
  has_secure_password

  #validates :email, :presence => true, :length => { :maximum => 255 }, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => true }
  #validates :telephone, :presence => true
  #validates :fax, :presence => true
  #validates :qq, :presence => true
  #validates :bank, :presence => true
  #validates :address, :presence => true
end
