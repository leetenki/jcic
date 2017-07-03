require 'chinese_converter'
require 'era_ja/time'
require 'era_ja/date'
include ChineseConverter

class ProjectsController < ApplicationController
  before_action :logged_in, :only => [:new, :create, :index, :edit, :update, :destroy, :show, :need_delete, :signature, :generate_random_schedule, :temporary_report]
  before_action :init_company_codes, :only => [:new, :create, :edit, :update]
  before_action :logged_in_admin, :only => [:store_pdf]

  #create new project
  def new
    # default project
    @project = current_trader.projects.build
    @project.schedules.build
    @project.clients.build

    # new with copy target
    if(params[:schedule_copy_target] || params[:client_copy_target] || params[:full_copy_target])
      if(params[:full_copy_target])
        copy_target_id = params[:full_copy_target].to_i
      elsif(params[:schedule_copy_target])
        copy_target_id = params[:schedule_copy_target].to_i
      elsif(params[:client_copy_target])
        copy_target_id = params[:client_copy_target].to_i
      end

      # find target
      begin      
        if(is_admin? || has_authority?)
          target_project = Project.find_by(:id => copy_target_id)
        else
          target_project = current_trader.projects.find_by(:id => copy_target_id)
        end

        if(params[:full_copy_target])
          @project = create_full_copy(target_project)
          @stay_term_lock = true #used for schedule chain
        elsif(params[:schedule_copy_target])
          @project = create_schedule_copy(target_project)
          @stay_term_lock = true
        elsif(params[:client_copy_target])
          @project = create_client_copy(target_project)
        end
      rescue
        flash[:danger] = "拷贝失败．"      
      end
    end
  end

  # function to generate random schedule
  def generate_random_schedule
    @result = ""

    in_airport = ChineseConverter.japanesed(params[:in_airport])
    out_airport = ChineseConverter.japanesed(params[:out_airport])

    stay_term = params[:stay_term].to_i

    if(stay_term < 40 && stay_term > 0 && in_airport.length <= 5 && out_airport.length <= 5)
      # grouprize tokyo string
      tokyo_string = Regexp.new(/東京|东京|成田|成田|羽田|羽田/)
      if(in_airport.match(tokyo_string))
        in_airport = tokyo_string
      end
      if(out_airport.match(tokyo_string))
        out_airport = tokyo_string
      end

      # search by stay_term 
      #@projects = Project.where(:stay_term => stay_term, :has_full_schedule => true).includes(:schedules)
      @projects = Project.where("stay_term = ? and has_full_schedule = ?", stay_term, true).limit(1000).includes(:schedules)
      if(@projects && @projects.length > 0)

        # search by in_airport
        #@projects = @projects.sample(200)
        @strict_match_result = []
        @projects.each do |project|
          if(ChineseConverter.japanesed(project.schedules[0].plan).match(in_airport))
            @strict_match_result.push(project)
          end
        end
        if(@strict_match_result && @strict_match_result.length > 0)
          @projects = @strict_match_result
        end

        # search by out_airport
        @strict_match_result = []
        @projects.each do |project|
          if(ChineseConverter.japanesed(project.schedules[project.schedules.length-1].plan).match(out_airport))
            @strict_match_result.push(project)
          end
        end
        if(@strict_match_result && @strict_match_result.length > 0)
          @projects = @strict_match_result
        end

        @result = @projects.sample(1)[0].schedules.to_json({:only => [:plan, :hotel]})
      end
    end

    render :text => @result
  end

  def create
    @project = current_trader.projects.build(project_params)
    regenerate_project

    #render :text => @project.errors.messages
    if(@project.valid?)
      #custom check schedules
      if(@project.schedules.length != @project.stay_term)
        @project.errors.add(:schedules, "旅程表与日本入境／出境日期不符合.")
      else
        @term = 0;
        @project.schedules.each do |schedule|
          if((schedule.date - @project.date_arrival).to_i != @term)
            @project.errors.add(:schedules, "旅程表与在留日期不符合.")            
            break
          end
          @term += 1;
        end
      end

      #custom check doubled visa
      matched_projects = Project.where("trader_id = ? and china_company_name = ? and representative_name_chinese = ? and total_people = ? and visa_type = ? and date_arrival = ? and date_leaving = ?", @project.trader_id, @project.china_company_name, @project.representative_name_chinese, @project.total_people, @project.visa_type, Date.parse(@project.date_arrival.to_s), Date.parse(@project.date_leaving.to_s))
      if(matched_projects.length > 0)
        mached = false
        matched_projects.each do |mached_project|
          if(!mached_project.delete_request && mached_project.status != "deleted" && mached_project.clients[0].passport_no == @project.clients[0].passport_no)
            mached = true
            break;
          end
        end

        if(mached)
          @project.errors.add(:trader_id, "此签证已有登录，不可重复登录。")
        end
      end
    end

    #custom check clients
    if(@project.clients.length == 0)
      @project.errors.add(:clients, "客户数不可为零.")
      @project.clients.build
    elsif(@project.visa_type == "group" && @project.clients.length > 40)
      @project.errors.add(:clients, "团签客户数不可超过40人")
    elsif(@project.visa_type != "group" && @project.clients.length > 10)
      @project.errors.add(:clients, "个签，3年，5年多次人数不可超过10人")
    else
      @project.total_people = @project.clients.length
    end

    if(!@project.errors.any?)
      @project.save
      flash[:success] = "签证单提交完毕，请仔细查看招聘保证書. 若有错误请立即修改. #{@project.trader.editable_min.to_s}分钟后您将无权修改."
      #message = "您的订单：#{@project.china_company_name}, #{@project.representative_name_chinese}(他" + (@project.clients.length-1).to_s + "人)\r\n价格：" + get_project_price(@project).to_s
      #if(@project.trader.email && @project.trader.email.match(/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/))
        #system("echo '#{message}' | mutt -n -F ~/.mutt/muttrc -s '提交完毕' #{@project.trader.email}");
      #elsif(@project.trader.qq && @project.trader.qq.match(/[0-9]{5,}/))
        #system("echo '#{message}' | mutt -n -F ~/.mutt/muttrc -s '提交完毕' " + @project.trader.qq.match(/[0-9]{5,}/)[0]);
      #end
      #flash[:success] = "签证单提交完毕，请仔细查看身员保证单. 若有错误，请立即修改. " + (@project.trader.editable_min / 60).to_s + "小时后您将无权修改."
      redirect_to projects_path
    else
      render 'new'
    end
  end

  #edit
  def edit
    if(is_admin? || current_trader.authority == "all")
      @project = Project.find(params[:id])
    else
      if(current_trader.authority == "self")
        @project = current_trader.projects.find(params[:id])
      else
        @traders = Trader.where(:invoice_company => current_trader.authority);
        @ids = Array.new(0, nil)
        @traders.each do |trader|
          @ids.push(trader.id)
        end
        @project = Project.where("trader_id in (?)", @ids).find(params[:id])
      end

      if(!has_authority? && !is_project_editable(@project))
        flash[:danger] = "对不起，此签证已无法修改."
        redirect_to projects_path
      end
    end
  end

  def update
    dates = [];    
    destroy_ids = [];
    client_destroy_ids = [];

    #render :text => project_params
#=begin
    if(is_admin? || current_trader.authority == "all")
      @project = Project.find_by(:id => params[:id])
      @project.record_timestamps = false
    else
      if(current_trader.authority == "self")
        @project = current_trader.projects.find_by(:id => params[:id])
      else
        @traders = Trader.where(:invoice_company => current_trader.authority);
        @ids = Array.new(0, nil)
        @traders.each do |trader|
          @ids.push(trader.id)
        end
        @project = Project.where("trader_id in (?)", @ids).find_by(:id => params[:id])       
      end

      if(!has_authority? && !is_project_editable(@project))
        flash[:danger] = "对不起，此签证已无法修改."
        redirect_to projects_path
        return
      end      
    end
    @project.assign_attributes(project_params)
    regenerate_project

    if(@project.valid?)
      #custom validate clients
      project_params["clients_attributes"].each do |client_attr|
        if(client_attr[1]["passport_no"].nil?)
          if(!client_attr[1]["id"].nil? && !@project.clients.find_by(:id => client_attr[1]["id"]).nil?)
            client_destroy_ids.push(client_attr[1]["id"]);
          else
            @project.errors.add(:clients, "删除对象的ID不存在");
          end
        end
      end

      if(@project.clients.length == client_destroy_ids.length)
        @project.errors.add(:clients, "客户数不可为零.")        
      else
        @project.total_people = @project.clients.length - client_destroy_ids.length
      end

      #custom validate schedules
      project_params["schedules_attributes"].each do |schedule_attr|
        if(!schedule_attr[1]["date"].nil?)
          dates.push(Date.parse(schedule_attr[1]["date"].to_s))
        elsif(!schedule_attr[1]["id"].nil? && !@project.schedules.find_by(:id => schedule_attr[1]["id"]).nil?)
          destroy_ids.push(schedule_attr[1]["id"]);
        else
          @project.errors.add(:schedules, "旅程日期不符合格式.")
          break;
        end
      end

      if(dates.length != @project.stay_term)
        @project.errors.add(:schedules, "旅程表与日本入境／出境日期不符合.")
      else
        @term = 0;
        dates.each do |date|
          if((date - @project.date_arrival).to_i != @term)
            @project.errors.add(:schedules, "旅程表与在留日期不符合.")            
            break
          end
          @term += 1;
        end
      end
    end

    if(is_admin? || !@project.errors.any?)
      destroy_ids.each do |destroy_id|
        @project.schedules.find_by(:id => destroy_id).destroy;
      end
      client_destroy_ids.each do |client_destroy_id|
        @project.clients.find_by(:id => client_destroy_id).destroy;
      end

      if(is_admin?)
        @project.save :validate => false
      else
        @project.save
      end

      flash[:success] = "签证修改完毕,您还有#{@project.trader.editable_min}分钟时间可以检查.若有错误,请立即修改."
      redirect_to projects_path
    else
      render 'new'
    end
#=end
  end

  #destroy
  def destroy
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
    else
      @project = nil#current_trader.projects.find_by(:id => params[:id])
    end

    if(@project.nil?)
      flash[:danger] = "对不起，无法删除电签."
    elsif(!is_admin? && (@project.status == "completed" || @project.date_arrival < Date.today))
      flash[:danger] = "对不起，您所选择的电签表已无法删除."        
    else
      @project.destroy
      flash[:success] = "成功删除此电签！"
    end
    redirect_to projects_path
  end  

  def index
    if logged_in?
      if(is_admin?)
        @projects = current_trader.search_projects(Project.where('created_at >= ?', Time.now - 90 * 24 * 60 * 60), params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
=begin
        if(current_trader.authority == "all")
          @projects = current_trader.search_projects(Project.all, params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
        elsif(current_trader.authority == "self")
          @projects = current_trader.search_projects(current_trader.projects, params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
        else
          @traders = Trader.where(:invoice_company => current_trader.authority);
          @ids = Array.new(0, nil)
          @traders.each do |trader|
            @ids.push(trader.id)
          end
          @projects = current_trader.search_projects(Project.where("trader_id in (?)", @ids), params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
        end
=end
      else
        last_invoice_date = (Date.today-1.month).strftime("%Y-%m-01") 
        if current_trader.invoice_company == 'jtg' && current_trader.payoffs.where(status: last_invoice_date.to_s).empty? && current_trader.projects.length > 0
          first_project_date = current_trader.projects.first.created_at
          if first_project_date.year != Date.today.year || first_project_date.month != Date.today.month
            flash[:danger] = "系统提示: #{(Date.today-1.month).month}月份账单未确认支付。请在#{Date.today.month}月10日之前续费并及时联系我们。"
          end
        end
        if(current_trader.authority == "self")
          @projects = current_trader.search_projects_by_keyword(current_trader.projects, params[:keyword]).order("id desc")
          if(current_trader.bank.match(/警告/))
            flash[:danger] = current_trader.bank
          end
        elsif(current_trader.authority == "all")
          @projects = current_trader.search_projects_by_keyword(Project.all, params[:keyword]).order("id desc")
        else
          @traders = Trader.where(:invoice_company => current_trader.authority);
          @ids = Array.new(0, nil)
          @traders.each do |trader|
            @ids.push(trader.id)
          end
          @projects = current_trader.search_projects_by_keyword(Project.where("trader_id in (?)", @ids), params[:keyword]).order("id desc")
        end
      end
    end
  end

  #create pdf
  def show
    visa_type_table = {"individual" => "个签", "group" => "团签", "3years" => "冲绳东北六县多次", "5years" => "一定经济能力多次"}

    if(is_admin? || current_trader.authority == "all")
      @project = Project.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    elsif(current_trader.authority == "self")
      @project = current_trader.projects.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    else
      @traders = Trader.where(:invoice_company => current_trader.authority);
      @ids = Array.new(0, nil)
      @traders.each do |trader|
        @ids.push(trader.id)
      end
      @project = Project.where("trader_id in (?)", @ids).where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    end

    @visa_company = CompanyCode.where("code = ?", @project.china_company_code)
    @guarantee_mode = current_trader.guarantee_mode

    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string :template => "/projects/show"
        pdf = PDFKit.new(html, :encoding => "UTF-8");
        pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
        send_data pdf.to_pdf, :filename => "#{@project.representative_name_chinese}（#{@project.clients.length}人）" + visa_type_table[@project.visa_type] + ".pdf", :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  def report
    @project = Project.where("system_code = ?", params[:id]).limit(1).includes(:clients, :schedules)[0]
    @visa_company = CompanyCode.find_by(code: @project.china_company_code)

    if params[:person_in_charge_name]
        @project.in_charge_person = params[:person_in_charge_name]
    end
    if params[:person_in_charge_phone]
        @project.in_charge_phone = params[:person_in_charge_phone]
    end

    respond_to do |format|
      format.html
      format.pdf do
        case @project.visa_type
        when 'individual'
          html = render_to_string :template => "/projects/temporary_report_individual"
        when '3years'
          html = render_to_string :template => "/projects/temporary_report_3_years"
        when '5years'
          html = render_to_string :template => "/projects/temporary_report_5_years"
        when 'group'
          html = render_to_string :template => "/projects/temporary_report_group"
        end
        pdf = PDFKit.new(html, :encoding => "UTF-8");
        pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/temporary_report.css"
        send_data pdf.to_pdf, :filename => "#{@project.system_code}.pdf", :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  def temporary_report
    if(is_admin? || current_trader.authority == "all")
      @project = Project.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    elsif(current_trader.authority == "self")
      @project = current_trader.projects.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    else
      @traders = Trader.where(:invoice_company => current_trader.authority);
      @ids = Array.new(0, nil)
      @traders.each do |trader|
        @ids.push(trader.id)
      end
      @project = Project.where("trader_id in (?)", @ids).where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    end

    @visa_company = CompanyCode.find_by(code: @project.china_company_code)

    respond_to do |format|
      format.html
      format.pdf do
        case @project.visa_type
        when 'individual'
          html = render_to_string :template => "/projects/temporary_report_individual"
        when '3years'
          html = render_to_string :template => "/projects/temporary_report_3_years"
        when '5years'
          html = render_to_string :template => "/projects/temporary_report_5_years"
        when 'group'
          html = render_to_string :template => "/projects/temporary_report_group"
        end
        pdf = PDFKit.new(html, :encoding => "UTF-8");
        pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/temporary_report.css"
        send_data pdf.to_pdf, :filename => "#{@project.system_code}.pdf", :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  #updaters 
  def update_status
    if(is_admin?)
      @project = Project.find_by(:id => params[:id]);
      if(params[:status] == "deleted")
        @project.assign_attributes({:status => params[:status], :delete_request => false})
      else
        @project.assign_attributes :status => params[:status];
      end

      if(params[:system_code].present?)
        @project.assign_attributes :system_code => params[:system_code]
      end

      @project.record_timestamps = false
      @project.save :validate => false;
      #render :text => @project.trader.id
      flash[:success] = " 状态修改为 '" + status_type_str(params[:status]) + "' (@trader.id = " + @project.trader.id.to_s + ", " + @project.trader.company_name.to_s + ", " + @project.trader.person_name +  ")  (@project.id = " + @project.id.to_s + ", " + @project.china_company_name.to_s + ", " + @project.created_at.to_s + ")"
    end

    if(params[:status] == "committed")
      redirect_to "/admin/upload_pdf?id=#{params[:id]}"
    else
      redirect_to projects_path
    end
    #redirect_to request.referrer || projects_path
  end

  def update_confirmation
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
      @project.assign_attributes :confirmation => params[:confirmation]
      flash[:success] = "confirmation 修改为 " + params[:confirmation] + " 状态."
    else
      @project = current_trader.projects.find_by(:id => params[:id])
      @project.assign_attributes :confirmation => "confirmed"
      flash[:success] = "谢谢合作,我们即将向观光厅汇报."
    end

    @project.record_timestamps = false
    @project.save :validate => false;
    redirect_to request.referrer || projects_path
  end

  def update_payment
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
      @project.assign_attributes :payment => params[:payment]
      @project.record_timestamps = false
      @project.save :validate => false;
      flash[:success] = "payment 修改为 " + params[:payment] + " 状態."
    end

    redirect_to request.referrer || projects_path
  end

  def delete_request
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
      flash[:success] = "delete_request 修改为 " + "true" + " 状態."
    else
      if(current_trader.authority == "all")
        @project = Project.find_by(:id => params[:id])
      elsif(current_trader.authority == "self")
        @project = current_trader.projects.find_by(:id => params[:id])
      else
        @traders = Trader.where(:invoice_company => current_trader.authority);
        @ids = Array.new(0, nil)
        @traders.each do |trader|
          @ids.push(trader.id)
        end
        @project = Project.where("trader_id in (?)", @ids).find_by(:id => params[:id])
      end
      if(!has_authority? && !is_project_deletable(@project))
        flash[:danger] = "对不起，此签证已无法删除."
        redirect_to projects_path
        return
      else
        flash[:success] = "申请完毕。我们会在1工作日之内确认并完全删除此签证。"
      end      
    end

    @project.record_timestamps = false
    @project.assign_attributes :delete_request => true
    @project.save :validate => false;
    redirect_to request.referrer || projects_path
  end

  def cancel_delete_request
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
      @project.record_timestamps = false
      @project.assign_attributes :delete_request => false
      @project.save :validate => false;
      flash[:success] = "delete_request 修改未 " + "false" + " 状態."
    end

    redirect_to request.referrer || projects_path
  end

  def store_pdf
    @project = Project.find_by(:id => params[:project][:id])
    @project.record_timestamps = false
    @project.assign_attributes :pdf => params[:project][:pdf]
    @project.save :validate => false;
    #render :text => "Succeed to upload file " + @project.pdf.url;
    flash[:success] = "Succeed to upload file " + @project.pdf.url
    redirect_to admin_upload_pdf_path
  end

  def signature
    if(is_admin? || current_trader.authority == "all")
      @project = Project.find_by(:id => params[:id])
    elsif(current_trader.authority == "self")
      @project = current_trader.projects.find_by(:id => params[:id])
    else
      @traders = Trader.where(:invoice_company => current_trader.authority);
      @ids = Array.new(0, nil)
      @traders.each do |trader|
        @ids.push(trader.id)
      end
      @project = Project.where("trader_id in (?)", @ids).find_by(:id => params[:id])      
    end
    if(!@project)
      redirect_to request.referrer || projects_path
    else
      @japan_company = Constants::JAPAN_SIDE_COMPANY[@project.japan_company.intern]
      render "signature", :layout => false;
    end
  end

  private
  def regenerate_project
    if @project.departure_time.to_s.match(/00:00:00/)
      @project.departure_time = ""
    end
    if @project.arrival_time.to_s.match(/00:00:00/)
      @project.arrival_time = ""
    end
    
    if(@project.visa_type == "group")
      if(current_trader.group_japan_company == "random")
        @project.japan_company = Constants::GROUP_VISA[Random.rand(Constants::GROUP_VISA.length)]
      else
        @project.japan_company = current_trader.group_japan_company.intern
      end
    else
      if(current_trader.individual_japan_company == "random")
        @project.japan_company = Constants::INDIVIDUAL_VISA[Random.rand(Constants::INDIVIDUAL_VISA.length)]
      else
        @project.japan_company = current_trader.individual_japan_company.intern
      end
    end

    # check if has full schedule
    if(@project.check_full_schedule())
      @project.has_full_schedule = true
    end
  end

  # create full copy project
  def create_full_copy(target_project)
    project = current_trader.projects.build
    project.stay = target_project.stay
    project.visit = target_project.visit
    project.schedules.build
    project.clients.build

    # copy clients
    project.total_people = target_project.total_people
    project.representative_name_english = target_project.representative_name_english
    project.representative_name_chinese = target_project.representative_name_chinese
    project.total_man = target_project.total_man
    project.total_woman = target_project.total_woman
    while(project.clients.length < target_project.clients.length)
      project.clients.push(Client.new)
    end
    target_project.clients.each_with_index do |client, index|
      project.clients[index].name_chinese = client.name_chinese
      project.clients[index].name_english = client.name_english
      project.clients[index].gender = client.gender
      project.clients[index].hometown = client.hometown
      project.clients[index].birthday = client.birthday
      project.clients[index].passport_no = client.passport_no
      project.clients[index].job = client.job
    end

    # copy schedules
    project.date_arrival = target_project.date_arrival
    project.stay_term = target_project.stay_term
    project.date_leaving = project.date_arrival + project.stay_term - 1
    project.departure_time = target_project.departure_time
    project.arrival_time = target_project.arrival_time
    while(project.schedules.length < target_project.schedules.length)
      project.schedules.push(Schedule.new)
    end
    target_project.schedules.each_with_index do |schedule, index|
      project.schedules[index].plan = schedule.plan
      project.schedules[index].hotel = schedule.hotel
      project.schedules[index].date = schedule.date
    end

    # copy full
    project.china_company_name = target_project.china_company_name
    project.china_company_code = target_project.china_company_code
    project.visa_type = target_project.visa_type
    project.japan_airport = target_project.japan_airport
    project.flight_name = target_project.flight_name
    project.china_airport = target_project.china_airport
    project.in_charge_person = target_project.in_charge_person
    project.in_charge_phone = target_project.in_charge_phone
    project.ticket_no = target_project.ticket_no

    return project
  end

  # create copy with only client
  def create_client_copy(target_project)
    project = current_trader.projects.build
    project.schedules.build
    project.clients.build

    # copy clients
    project.total_people = target_project.total_people
    project.representative_name_english = target_project.representative_name_english
    project.representative_name_chinese = target_project.representative_name_chinese
    project.total_man = target_project.total_man
    project.total_woman = target_project.total_woman
    while(project.clients.length < target_project.clients.length)
      project.clients.push(Client.new)
    end
    target_project.clients.each_with_index do |client, index|
      project.clients[index].name_chinese = client.name_chinese
      project.clients[index].name_english = client.name_english
      project.clients[index].gender = client.gender
      project.clients[index].hometown = client.hometown
      project.clients[index].birthday = client.birthday
      project.clients[index].passport_no = client.passport_no
      project.clients[index].job = client.job
    end

    return project
  end

  # create copy with only schedule
  def create_schedule_copy(target_project)
    project = current_trader.projects.build
    project.schedules.build
    project.clients.build

    # copy schedule
    project.date_arrival = target_project.date_arrival
    project.stay_term = target_project.stay_term
    project.date_leaving = project.date_arrival + project.stay_term - 1
    project.departure_time = target_project.departure_time
    project.arrival_time = target_project.arrival_time
    while(project.schedules.length < target_project.schedules.length)
      project.schedules.push(Schedule.new)
    end
    target_project.schedules.each_with_index do |schedule, index|
      project.schedules[index].plan = schedule.plan
      project.schedules[index].hotel = schedule.hotel
      project.schedules[index].date = schedule.date
    end

    return project
  end


  @company_codes
  def init_company_codes
    @company_codes = CompanyCode.where("status = ?", "working")
    @company_codes.each do |c|
      c.search_text = c.code.gsub(/[-]/, "").downcase + ChineseConverter.simplized(c.locate+c.name)
    end
  end

  def project_params
    params.require(:project).permit(
      :china_company_name, :china_company_code, :visa_type, :total_people, :representative_name_english, :representative_name_chinese, :in_charge_person, :in_charge_phone, :japan_airport, :china_airport, :flight_name, :departure_time, :arrival_time, :date_arrival, :date_leaving, :from, :to, :payment, :confirmation, :status, :delete_request, :ticket_no,
      :extra,
      :stay => [],
      :visit => [],
      :schedules_attributes => [:id, :date, :plan, :hotel], 
      :clients_attributes => [:id, :name_chinese, :name_english, :gender, :hometown, :birthday, :passport_no, :job]
    )
  end
end
