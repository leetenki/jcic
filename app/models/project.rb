require 'utility'
include Utility

class Project < ActiveRecord::Base
  #uploader
  mount_uploader :pdf, PdfUploader

  #relationships
  belongs_to :trader
  has_many :schedules, -> { order("id") }, :dependent => :destroy
  has_many :clients, -> { order("id") }, :dependent => :destroy
  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :clients

  paginates_per Constants::PAGENATION_COUNT

  #validation
  validates :trader_id, :presence => true
  validate :validate_china_company_name
  validate :validate_china_company_code
  validate :validate_visa_type
  validate :validate_representative_name_chinese
  validate :validate_representative_name_english
  validate :validate_dates
  validate :validate_total_people
  validate :validate_in_charge_person
  validate :validate_in_charge_phone
  validate :validate_japan_airport
  validate :validate_china_airport
  validate :validate_flight_name
  validate :validate_departure_and_arrival_time
  validate :validate_japan_company
  validate :validate_stay_and_visit


  def validate_japan_airport
    if(!japan_airport.present?)
      #errors.add(:japan_airport, "您未输入日本出发地点.")
    elsif(!zenkaku?(japan_airport))
      errors.add(:japan_airport, "日本出发地点只可输入汉字.")
    elsif japan_airport.length > 5
      errors.add(:japan_airport, "日本出发地点不可超过5字.")      
    end
  end

  def validate_china_airport
    if(!china_airport.present?)
      #errors.add(:china_airport, "您未输入中国到达地点.")
    elsif(!zenkaku?(china_airport))
      errors.add(:china_airport, "中国到达地点只可输入汉字.")
    elsif china_airport.length > 5
      errors.add(:china_airport, "中国到达地点不可超过5字.")      
    end
  end

  def validate_flight_name
    if(!flight_name.present?)
      #errors.add(:flight_name, "您未输入回国航班号.")
    elsif flight_name.match(/[^a-zA-Z0-9]/)
      errors.add(:flight_name, "航班号只可输入英文字母与数字.")
    elsif flight_name.length > 10
      errors.add(:flight_name, "航班号不可超过10字.")      
    end
  end

  def validate_departure_and_arrival_time
    if(!departure_time.present?)
      #errors.add(:departure_time, "您未输入回国航班出发时间.")
    end

    if(!arrival_time.present?)
      #errors.add(:arrival_time, "您未输入回国航班到达时间.")
    end
  end

  def validate_in_charge_person
    if(!in_charge_person.present?)
      #errors.add(:in_charge_person, "您未输入公司(送签社)担当者姓名.")
    elsif in_charge_person.length > 5
      errors.add(:in_charge_person, "公司（送签社）担当者姓名不可超过5字.")      
    end
  end

  def validate_in_charge_phone
    if(!in_charge_phone.present?)
      #errors.add(:in_charge_phone, "您未输入公司担当者的电话号码.")
    elsif in_charge_phone.match(/[^-0-9]/)
      errors.add(:in_charge_phone, "公司担当者电话只可输入数字.")
    elsif in_charge_phone.length > 20
      errors.add(:in_charge_phone, "公司担当者电话号码不可超过20位.")      
    end
  end

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

  def validate_stay_and_visit
    if visa_type == "3years"
        if visit.length == 0
            errors.add(:visit, "您未选择访问城市.")
        end

        if stay.length == 0
            errors.add(:stay, "您未选择住宿城市.")
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
    elsif(representative_name_chinese.length > 8)
      errors.add(:representative_name_chinese, "代表人名（简体字）不可超过8字.")   
    elsif(hankaku?(representative_name_chinese))
      errors.add(:representative_name_chinese, "中文名只可输入简体字.")      
    end
  end

  def validate_representative_name_english
    if(!representative_name_english.present?)
      errors.add(:representative_name_english, "您未输入代表人名（拼音）.")
    elsif(representative_name_english.length > 15)
      errors.add(:representative_name_english, "代表人名（拼音）不可超过20字.")   
    elsif(!hankaku?(representative_name_english))
      errors.add(:representative_name_english, "代表人名（拼音）只可输入英文字母或半角空格.")      
    end
  end

  def validate_dates
    date_valid = true
    if(!date_arrival.present? || date_arrival < Date.today+1)
      errors.add(:date_arrival, "日本入境日期不正确.");
      date_valid = false
    end

    if(!date_leaving.present? || date_leaving < Date.today+1)
      errors.add(:date_leaving, "日本出境日期不正确.");
      date_valid = false
    end

    if(date_valid)
      if(date_arrival > date_leaving)
        errors.add(:date_leaving, "出境日期小于入境日期.")
      elsif(visa_type == "individual" && date_leaving > date_arrival+30)
        errors.add(:date_leaving, "个人签证只可30日以内.")        
      else
        self.stay_term = (date_leaving - date_arrival).to_i + 1
      end
    end
  end

  def validate_total_people
    if(!total_people.present? || total_people <= 0 || total_people > 40)
      errors.add(:total_people, "总人数不正确.总人数必须1人以上，40人之内");
    end

    if(visa_type.present? && visa_type != "group" && total_people > 10)
      errors.add(:total_people, "除团体签证以外，人数不可超过10人.");      
    end

    self.total_man = 0
    self.total_woman = 0
    self.clients.each do |client|
      if client.gender == "male"
        self.total_man += 1
      else
        self.total_woman += 1
      end
    end
  end

  def validate_japan_company
    if(visa_type == "group")
      if(self.trader.group_japan_company == "random")
        self.japan_company = Constants::GROUP_VISA[Random.rand(Constants::GROUP_VISA.length)]
      else
        self.japan_company = self.trader.group_japan_company.intern
      end
    else
      if(self.trader.individual_japan_company == "random")
        self.japan_company = Constants::INDIVIDUAL_VISA[Random.rand(Constants::INDIVIDUAL_VISA.length)]
      else
        self.japan_company = self.trader.individual_japan_company.intern
      end
    end
  end

  # used in validation for object to check full schedule
  def check_full_schedule
    has_full_schedule = true
    schedules = self.schedules
    schedules.each_with_index do |schedule, index|
      if(index != 0 && index != schedules.length-1)
        #if(schedule[:plan].length == 0 || schedule[:hotel].length == 0)
        if(schedule[:plan].strip.length == 0)
          has_full_schedule = false
          break
        end
      end
    end

    return has_full_schedule
  end

  ############ used for upgrad system (only used once at 2016/1/13) ##########
  def self.upgrade_full_schedule(stay_term)
    projects = self.where(:stay_term => stay_term)
    projects.each do |project|
      p project.id
      if(project.check_full_schedule)
        project.assign_attributes({:has_full_schedule => true})
        p "has full schedule."
      else
        project.assign_attributes({:has_full_schedule => false})
        p "not has full schedule."
      end
      project.record_timestamps = false
      project.save :validate => false;      
    end

    return
  end

  ############ Sweep ##############
  def self.sweep(time = 185.days)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end

    p "delete projects created before " + time.ago.to_s(:db)
    self.where("created_at < '#{time.ago.to_s(:db)}' AND (payment = 'paid' OR status = 'deleted')").each do |project|
      project.destroy
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
