require 'chinese_converter'
require 'era_ja/time'
require 'era_ja/date'
include ChineseConverter

class ProjectsController < ApplicationController
  before_action :logged_in, :only => [:new, :create, :index, :edit, :update, :destroy, :show, :need_delete, :signature]
  before_action :init_company_codes, :only => [:new, :create, :edit, :update]
  before_action :logged_in_admin, :only => [:store_pdf]

  #create new project
  def new
    @project = current_trader.projects.build
    @project.schedules.build
    @project.clients.build
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
          if(!mached_project.delete_request && mached_project.status != "deleted")
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
    else
      @project.total_people = @project.clients.length
    end

    if(!@project.errors.any?)
      @project.save
      flash[:success] = "签证单提交完毕，请仔细查看招聘保证書. 若有错误，请立即修改. #{Constants::EDITABLE_MIN.to_s}分钟后您将无权修改."
      #message = "您的订单：#{@project.china_company_name}, #{@project.representative_name_chinese}(他" + (@project.clients.length-1).to_s + "人)\r\n价格：" + get_project_price(@project).to_s
      #if(@project.trader.email && @project.trader.email.match(/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/))
        #system("echo '#{message}' | mutt -n -F ~/.mutt/muttrc -s '提交完毕' #{@project.trader.email}");
      #elsif(@project.trader.qq && @project.trader.qq.match(/[0-9]{5,}/))
        #system("echo '#{message}' | mutt -n -F ~/.mutt/muttrc -s '提交完毕' " + @project.trader.qq.match(/[0-9]{5,}/)[0]);
      #end
      #flash[:success] = "签证单提交完毕，请仔细查看身员保证单. 若有错误，请立即修改. " + Constants::EDITABLE_HOUR.to_s + "小时后您将无权修改."
      redirect_to projects_path
    else
      render 'new'
    end
  end

  #edit
  def edit
    if(is_admin?)
      @project = Project.find(params[:id])
    else
      @project = current_trader.projects.find(params[:id])
      if(!is_project_editable(@project))
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
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
      @project.record_timestamps = false
    else
      @project = current_trader.projects.find_by(:id => params[:id])
      if(!is_project_editable(@project))
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

      flash[:success] = "签证修改完毕,您还有#{Constants::EDITABLE_MIN.to_s}分钟时间可以检查.若有错误,请立即修改."
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
        @projects = current_trader.search_projects(Project.all, params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
      else
        @projects = current_trader.search_projects_by_keyword(current_trader.projects, params[:keyword]).order("id desc")
      end
    end
  end

  #create pdf
  def show
    visa_type_table = {"individual" => "个签", "group" => "团签", "3years" => "三年多次", "5years" => "五年多次"}

    if(is_admin?)
      @project = Project.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
    else
      #@project = current_trader.projects.find_by(:id => params[:id])
      @project = current_trader.projects.where("id = ?", params[:id]).includes(:clients, :schedules)[0]
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

    redirect_to "/admin/upload_pdf?id=#{params[:id]}"
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
      @project = current_trader.projects.find_by(:id => params[:id])
      if(!is_project_deletable(@project))
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
    redirect_to projects_path
  end

  def signature
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
    else
      @project = current_trader.projects.find_by(:id => params[:id])
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
      :schedules_attributes => [:id, :date, :plan, :hotel], 
      :clients_attributes => [:id, :name_chinese, :name_english, :gender, :hometown, :birthday, :passport_no, :job]
    )
  end
end
