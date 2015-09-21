require 'utility.rb'
include Utility

class Client < ActiveRecord::Base
  belongs_to :project

  validate :validate_name_chinese
  validate :validate_name_english
  validate :validate_gender
  validate :validate_hometown
  validate :validate_passport_no
  validate :validate_birthday

  def validate_name_chinese
    if(!name_chinese.present?)
      errors.add(:name_chinese, "您未输入中文姓名.")
    elsif(name_chinese.length > 10)
      errors.add(:name_chinese, "中文姓名不可超过10字.")   
    elsif(hankaku?(name_chinese))
      errors.add(:name_chinese, "中文名只可输入简体汉字.")      
    end
  end

  def validate_name_english
    if(!name_english.present?)
      errors.add(:name_english, "您未输入英文姓名.")
    elsif(name_english.length > 30)
      errors.add(:name_english, "英文姓名不可超过30字.")   
    elsif(!hankaku?(name_english))
      errors.add(:name_english, "英文姓名只可输入英文字母或半角空格.")      
    end
  end

  def validate_gender
    gender_type = ["male", "female"];

    if(!gender_type.present?)
      errors.add(:gender, "您未选择性别.")
    elsif(!gender_type.include?(gender))
      errors.add(:gender, "性别只可选择男或女.")
    end
  end

  def validate_hometown
    if(!hometown.present?)
      errors.add(:hometown, "您未输入签证发行地.")      
    elsif(hometown.length > 10)
      errors.add(:hometown, "签证发行地不可超过10字.")
    end
  end  

  def validate_passport_no
    if(!passport_no.present?)
      errors.add(:passport_no, "您未输入旅护照号.")    
    elsif(!hankaku?(passport_no))
      errors.add(:passport_no, "护照号止可输入英文字母或数字.")        
    elsif(passport_no.length < 8 || passport_no.length > 11)
      #only 8 or 9 or 10 or 11 digit
      errors.add(:passport_no, "护照号位数不正确.")
    end
  end  

  def validate_birthday
    if(!birthday.present?)
      errors.add(:birthday, "出身日期不正确.");
    end
  end
end
