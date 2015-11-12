module ApplicationHelper
  def last_day(origin_date)
    return Date.civil(origin_date.year, origin_date.month, -1)
  end

  def first_day(origin_date)
    return Date.civil(origin_date.year, origin_date.month, 1)
  end

  def visa_type_str(visa_type)
    visa_type_table = Constants::VISA_TYPE_TABLE
    return visa_type_table[visa_type] 
  end

  def visa_type_str_short(visa_type)
    visa_type_table = {"individual" => "个人", "group" => "团体", "3years" => "三年", "5years" => "五年"}
    return visa_type_table[visa_type] 
  end

  def validation_mode_str(validation_mode)
    validation_mode_table = {"easy" => "简化", "simplest" => "超级简化", "strict" => "复杂"}
    return validation_mode_table[validation_mode] 
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
    confirmation_str = {"unconfirmed" => "未确认回国", "confirmed" => "已确认"}
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
    if(project.status=="uncommitted" && Time.now < (project.updated_at+60*Constants::EDITABLE_MIN))
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

  def get_projects_price(projects)
    total_price = 0
    projects.each do |project|
      total_price += get_project_price(project)
    end

    return total_price
  end

  def get_clients_length(projects)
    total_clients = 0;
    projects.each do |project|
      total_clients += project.clients.length
    end

    return total_clients
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

  def get_unit_price(project)
    people = project.clients.length
    unit_price = 0

    if(project.status == "deleted" || project.delete_request)
      unit_price = 0
    elsif(project.visa_type == "individual")
      unit_price = project.trader.indivisual_price
    elsif(project.visa_type == "3years")
      unit_price = project.trader.year_3_price
    elsif(project.visa_type == "5years")
      unit_price = project.trader.year_5_price
    elsif(project.visa_type == "group")
      if(project.trader.group_price_indivisual != 0)
        unit_price = project.trader.group_price_indivisual
      elsif(people <= 10)
        if(project.trader.indivisual_price * people > project.trader.group_price_11_20)
          unit_price = project.trader.group_price_11_20
        else
          unit_price = project.trader.indivisual_price
        end
      elsif(people <= 20)
        unit_price = project.trader.group_price_11_20
      elsif(people <= 30)
        unit_price = project.trader.group_price_21_30
      elsif(people <= 40)
        unit_price = project.trader.group_price_31_40
      end
    end

    return unit_price;
  end


  def get_payment_deadline(project)
    return Date.new(project.created_at.year, project.created_at.month+1, 10) 
  end
end