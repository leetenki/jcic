class Trader < ActiveRecord::Base
  #relationship
  has_many :projects

  paginates_per Constants::PAGENATION_COUNT

  #children method
  def between_dates(from, to)
    if from.present? && to.present?
      self.projects.where(created_at: Time.parse(from)..Time.parse(to))
    elsif from.present?
      self.projects.where('created_at >= ?', Time.parse(from))
    elsif to.present?
      self.projects.where('created_at <= ?', Time.parse(to))
    end
  end

  def paid_projects(payment)
    self.projects.where('payment == ?', payment)
  end

  def confirmed_projects(confirmation)
    self.projects.where('confirmation == ?', confirmation)
  end

  def search_by_status(status)
    self.projects.where('status == ?', status)
  end

  def on_delete_request(delete_request)
    self.projects.where('delete_request == ?', delete_request == "true")
  end

  def search_by_code(ticket_no)
    self.projects.where("ticket_no like '%" + ticket_no + "%'")    
  end

  def search_projects(projects, from, to, payment, confirmation, status, delete_request, ticket_no)
    if from.present? && to.present?
      projects = projects.where(created_at: Time.parse(from)..Time.parse(to))
    elsif from.present?
      projects = projects.where('created_at >= ?', Time.parse(from))
    elsif to.present?
      projects = projects.where('created_at <= ?', Time.parse(to))
    else
      projects = projects.all
    end

    if(!!payment)
      projects = projects.where('payment = ?', payment)
    end

    if(!!confirmation)
      projects = projects.where('confirmation = ?', confirmation)
    end

    if(!!status)
      projects = projects.where('status = ?', status)
    end

    if(!!delete_request)
      projects = projects.where('delete_request = ?', delete_request == "true")
    end

    if(!!ticket_no)
      projects = projects.where("ticket_no like '%" + ticket_no + "%'")
    end

    return projects;
  end

  #before_save
  before_save { self.email = email.downcase if email.present? }

  #validation name, email, password(password + password_confirmation -> password_digest)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :company_name, :presence => true
  validates :person_name, :presence => true
  validates :account, :presence => true
  validates :password_backup, :presence => true
  validates :indivisual_price, :presence => true
  validates :group_price_indivisual, :presence => true
  validates :group_price_11_20, :presence => true
  validates :group_price_21_30, :presence => true
  validates :group_price_31_40, :presence => true
  validates :year_3_price, :presence => true
  validates :year_5_price, :presence => true
  has_secure_password

  #validates :telephone, :presence => true
  #validates :email, :presence => true, :length => { :maximum => 255 }, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => true }
  #validates :fax, :presence => true
  #validates :qq, :presence => true
  #validates :bank, :presence => true
  #validates :address, :presence => true
end
