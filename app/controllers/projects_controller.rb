require 'chinese_converter'
require 'era_ja/time'
require 'era_ja/date'
include ChineseConverter

class ProjectsController < ApplicationController
  before_action :logged_in, :only => [:new, :create, :index, :edit, :update, :destroy, :show]
  before_action :init_company_codes, :only => [:new, :create, :edit, :update]

  #create new project
  def new
    @project = current_trader.projects.build
    @project.schedules.build
    @project.clients.build
  end

  def create
    @project = current_trader.projects.build(project_params)

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
      flash[:success] = "电子签证申请完毕，请再次检查. 1工作日之后将无法修改."
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
    end

  end

  def update
    dates = [];    
    destroy_ids = [];
    client_destroy_ids = [];

    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
    else
      @project = current_trader.projects.find_by(:id => params[:id])
    end
    @project.assign_attributes(project_params)

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

    if(!@project.errors.any?)
      destroy_ids.each do |destroy_id|
        @project.schedules.find_by(:id => destroy_id).destroy;
      end
      client_destroy_ids.each do |client_destroy_id|
        @project.clients.find_by(:id => client_destroy_id).destroy;
      end
      @project.save

      flash[:success] = "电子签证修改更新完毕."
      redirect_to projects_path
    else
      render 'new'
    end
  end

  #destroy
  def destroy
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
    else
      @project = current_trader.projects.find_by(:id => params[:id])
    end

    if(@project.nil?)
      flash[:danger] = "对不起，您所选择的电签不存在."
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
        @projects = Project.all.order("id desc")
      else
        @projects = current_trader.projects.order("id desc")
      end
    end
  end

  #create pdf
  def show
    @project = Project.find_by(:id => params[:id])
    @visa_company = CompanyCode.where("code = ?", @project.china_company_code)

    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string :template => "/projects/show"
        pdf = PDFKit.new(html, :encoding => "UTF-8");
        pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"

        send_data pdf.to_pdf, :filename => "#{@project.id}.pdf", :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  def update_status
    if(is_admin?)
      @project = Project.find_by(:id => params[:id]);
      @project.update({:status => params[:status]});
      #render :text => @project.trader.id
      flash[:success] = " 状态修改为 '" + status_type_str(params[:status]) + "' (@trader.id = " + @project.trader.id.to_s + ", " + @project.trader.company_name.to_s + ", " + @project.trader.person_name +  ")  (@project.id = " + @project.id.to_s + ", " + @project.china_company_name.to_s + ", " + @project.created_at.to_s + ")"
    end

    redirect_to projects_path
  end

  private
  @company_codes

  def init_company_codes
    @company_codes = CompanyCode.where("status = ?", "working")
    @company_codes.each do |c|
      c.search_text = c.code+ChineseConverter.simplized(c.locate+c.name)
    end
  end

  def project_params
    params.require(:project).permit(:china_company_name, :china_company_code, :visa_type, :total_people, :representative_name_english, :representative_name_chinese, :date_arrival, :date_leaving, :schedules_attributes => [:id, :date, :plan, :hotel], :clients_attributes => [:id, :name_chinese, :name_english, :gender, :hometown, :birthday, :passport_no])
  end
end
