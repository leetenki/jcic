require 'utility.rb'
include Utility

class Project < ActiveRecord::Base
  #relationships
  belongs_to :trader
  has_many :schedules, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :clients

  #validation
  validates :trader_id, :presence => true
  validate :validate_china_company_name
  validate :validate_china_company_code
  validate :validate_visa_type
  validate :validate_representative_name_chinese
  validate :validate_representative_name_english
  validate :validate_dates
  validate :validate_total_people

  def validate_china_company_name
    if(!china_company_name.present?)
      errors.add(:china_company_name, "您未输入中国旅行社名.")
    end
  end

  def validate_china_company_code
    if(china_company_name.present?) 
      company_infos = CompanyCode.where("status = ?", "working")
      company_names = company_infos.map{|company_info| company_info.name};
      company_codes = company_infos.map{|company_info| company_info.code};
      if(company_names.include?(china_company_name))
        self.china_company_code = company_codes[company_names.index(china_company_name)]
      else
        errors.add(:china_company_name, "您所输入的旅行社不存在.")
      end
    end
  end

  def validate_visa_type
    if(visa_type.present?)
      if(!["group", "individual", "3years", "5years"].include?(visa_type))
        errors.add(:visa_type, "您所选择的签证种类不正确.")
      end
    else
      errors.add(:visa_type, "您未选择签证种类.")      
    end
  end

  def validate_representative_name_chinese
    if(!representative_name_chinese.present?)
      errors.add(:representative_name_chinese, "您未输入代表人名（简体字）.")
    elsif(representative_name_chinese.length > 10)
      errors.add(:representative_name_chinese, "代表人名（简体字）不可超过10字.")   
    elsif(hankaku?(representative_name_chinese))
      errors.add(:representative_name_chinese, "中文名只可输入简体字.")      
    end
  end

  def validate_representative_name_english
    if(!representative_name_english.present?)
      errors.add(:representative_name_english, "您未输入代表人名（拼音）.")
    elsif(representative_name_english.length > 30)
      errors.add(:representative_name_english, "代表人名（拼音）不可超过30字.")   
    elsif(!hankaku?(representative_name_english))
      errors.add(:representative_name_english, "代表人名（拼音）只可输入英文字母或半角空格.")      
    end
  end

  def validate_dates
    date_valid = true
    if(!date_arrival.present? || date_arrival < Date.today)
      errors.add(:date_arrival, "日本入境日期不正确.");
      date_valid = false
    end

    if(!date_leaving.present? || date_leaving < Date.today)
      errors.add(:date_leaving, "日本出境日期不正确.");
      date_valid = false
    end

    if(date_valid)
      if(date_arrival > date_leaving)
        errors.add(:date_leaving, "出境日期小于入境日期.")
      else
        self.stay_term = (date_leaving - date_arrival).to_i + 1
      end
    end
  end

  def validate_total_people
    if(!total_people.present? || total_people <= 0 || total_people > 999)
      errors.add(:total_people, "总人数不正确.");
    end
  end

  ############ utility ############
  def hankaku?(str)
    return nil if str.nil?
    # 半角のみOKなので、全角が混ざっているとfalseが返る
    unless str.to_s =~ /^[ -~｡-ﾟ]*$/
      return false
    end
  return true
  end

  def zenkaku?(str)
    return nil if str.nil?
    # 全角のみOKなので、半角が混ざっているとfalseが返る
    unless str.to_s =~/^[^ -~｡-ﾟ]*$/
      return false
    end
    return true
  end
end
