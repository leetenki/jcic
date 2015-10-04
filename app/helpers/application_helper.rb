module ApplicationHelper
  def visa_type_str(visa_type)
    visa_type_table = {"individual" => "个人查证", "group" => "团体查证", "3years" => "三年多次", "5years" => "五年多次"}
    return visa_type_table[visa_type] 
  end

  def status_type_str(status)
    status_str = {"uncommitted" => "正在申请...", "waiting" => "正在等待", "committed" => "已发送完毕", "deleted" => "已删除"};
    return status_str[status]
  end

  def payment_type_str(payment)
    payment_str = {"unpaid" => "未支付", "paid" => "已支付"}
    return payment_str[payment]
  end

  def activation_type_str(activation)
    activation_str = {true => "有效", false => "停止"}
    return activation_str[activation]
  end

  def confirmation_type_str(confirmation)
    confirmation_str = {"unconfirmed" => "未确认回国", "confirmed" => "已确认回国"}
    return confirmation_str[confirmation]
  end

  def gender_str(gender)
    gender_type_str = {"male" => "男", "female" => "女"}
    return gender_type_str[gender]
  end

  def chinese_week_day(wday) 
    chinese_week_days = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
    return chinese_week_days[wday]
  end

  def is_project_editable(project)
    if(project.status=="uncommitted" && Time.now < (project.updated_at+60*60*Constants::EDITABLE_HOUR))
      return true
    else
      return false
    end
  end

  def is_project_deletable(project)
    if((project.status=="uncommitted" || project.status=="committed") && project.date_arrival - 1 >=  Date.today)
      return true;
    else
      return false;
    end
  end

  def is_project_disabled(project)
    if(project.delete_request == true || project.status == "deleted")
      return true
    else
      return false;
    end
  end

  def get_project_price(project)
    total_price = 0
    people = project.clients.length

    if(project.status == "deleted" || project.delete_request)
      total_price = 0
    elsif(project.visa_type == "individual")
      total_price = project.trader.indivisual_price * people
    elsif(project.visa_type == "3years")
      total_price = project.trader.year_3_price * people
    elsif(project.visa_type == "5years")
      total_price = project.trader.year_5_price * people
    elsif(project.visa_type == "group")
      if(project.trader.group_price_indivisual != 0)
        total_price = project.trader.group_price_indivisual * people
      elsif(people <= 10)
        total_price = [project.trader.indivisual_price * people, project.trader.group_price_11_20].min
      elsif(people <= 20)
        total_price = project.trader.group_price_11_20
      elsif(people <= 30)
        total_price = project.trader.group_price_21_30
      elsif(people <= 40)
        total_price = project.trader.group_price_31_40
      end
    end

    return total_price;
  end

  def get_payment_deadline(project)
    return Date.new(project.created_at.year, project.created_at.month+1, 10) 
  end
end