class Schedule < ActiveRecord::Base
  belongs_to :project

  validate :validate_plan
  validate :validate_hotel
  validate :validate_date

  def validate_date
    if(!date.present? || date < Date.today)
      errors.add(:date, "旅程日期不正确.");
    end
  end

  def validate_plan
    if(!plan.present?)
      #errors.add(:plan, "行动计划未填.")      
    elsif(plan.length > 200)
      errors.add(:plan, "行动计划不可超出200字.")
    end
  end

  def validate_hotel
    if(!hotel.present?)
      #errors.add(:plan, "旅馆未填.")
    elsif(hotel.length > 100)
      errors.add(:hotel, "住宿不可超出100字.")
    end
  end
end
