module ApplicationHelper
  def visa_type_str(visa_type)
    visa_type_table = {"individual" => "个人查证", "group" => "团体查证", "3years" => "三年多次", "5years" => "五年多次"}
    return visa_type_table[visa_type] 
  end

  def status_type_str(status)
    status_str = {"uncommitted" => "正在申请...", "waiting" => "等待状态", "committed" => "发送完毕"};
    return status_str[status];
  end


  def chinese_week_day(wday) 
    chinese_week_days = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
    return chinese_week_days[wday]
  end
end