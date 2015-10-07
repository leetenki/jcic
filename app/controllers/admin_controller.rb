class AdminController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :paid_all, :unpaid_all, :invoice, :useragent, :get_uncommitted_projects, :set_project_committed, :upload_pdf, :get_delete_requesting_projects, :get_delete_requesting_committed_projects, :set_delete_requesting_projects_deleted]
  before_action :initial_search, :only => [:paid_all, :unpaid_all]

  def index
    if !params[:trader_id].present? && !params[:from].present? && !params[:to].present?
      last_month = Date.today.last_month
      params[:from] = Date.new(last_month.year, last_month.month, 1).strftime("%Y/%m/%d");
      params[:to] = Date.new(last_month.year, last_month.month, -1).strftime("%Y/%m/%d");
      @waiting = true
    else
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc").includes(:clients, :schedules)
    end

    @traders = Trader.where("id <> 1")
  end

  def paid_all
    @projects.each do |project|
      if(project.payment == "unpaid" && project.status != "deleted" && !project.delete_request)
        project.assign_attributes(:payment => "paid")
        project.record_timestamps = false
        project.save :validate => false
      end
    end
    flash[:success] = "status == deleted, delete_request == true 以外，所有project的payment转换为paid"
    redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
  end

  def unpaid_all
    @projects.each do |project|
      if(project.payment == "paid" && project.status != "deleted" && !project.delete_request)
        project.assign_attributes(:payment => "unpaid")
        project.record_timestamps = false
        project.save :validate => false
      end
    end
    flash[:success] = "status == deleted, delete_request == true 以外，所有project的payment转换为unpaid"
    redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
  end

  def invoice
    if !params[:trader_id].present? || params[:trader_id] == "*" || !params[:from].present? || !params[:to].present?
      flash[:danger] = "请正确选择旅行社，开始日期，结束日期。"
      redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
      return
    else 
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).where("payment = ?", 'unpaid').order("id asc")   
      @trader = Trader.find_by(:id => params[:trader_id])
      html = render_to_string(:template => "/admin/invoice.pdf.erb")
      pdf = PDFKit.new(html, :encoding => "UTF-8"); 
      pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoice.css"
      send_data pdf.to_pdf, :filename => "#{@trader.company_name}_請求_#{params[:from]}_#{params[:to]}.pdf", :type => "application/pdf", :disposition => "inline"
    end
  end

  ####################### APIs #######################
  def get_uncommitted_projects
    @projects = Project.where("status = 'uncommitted' and delete_request = ?", false).order("id asc").includes(:clients, :schedules)
    @result = []
    @projects.each do |project| #check if not editable
      if(!is_project_editable(project))
        @result.push(project)
      end
    end

    text = @result.to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  def set_project_committed
    @project = Project.find(params[:id])
    p params
    @project.assign_attributes({:status => "committed", :system_code => params[:system_code]})
    p @project.system_code
    @project.record_timestamps = false
    @project.save :validate => false;
    render :text => "succeeded to update project " + @project.id.to_s
  end

  def upload_pdf
  end

  def get_delete_requesting_projects
    @projects = Project.where("delete_request = ?", true).order("id asc").includes(:clients, :schedules)    
    text = @projects.to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  def get_delete_requesting_committed_projects
    @projects = Project.where("delete_request = ? and system_code IS NOT NULL and status = 'committed'", true).order("id asc").includes(:clients, :schedules)    
    text = @projects.to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  def set_delete_requesting_projects_deleted
    @projects = Project.where("delete_request = ?", true).order("id asc")
    @projects.each do |project|
      project.assign_attributes(:status => "deleted", :delete_request => false)
      project.record_timestamps = false
      project.save :validate => false;
    end
    render :text => "succeeded to delete " + @projects.length.to_s + " projects."
  end

  #action to testing and detect user agent
  def useragent    
  end


private
  def initial_search
    @traders = Trader.where("id <> 1")
    @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc").includes(:clients, :schedules)
  end

  def search_projects(id, from, to)
    if from.present? && to.present?
      projects = Project.where(created_at: Time.parse(from)..Time.parse(to))
    elsif from.present?
      projects = Project.where('created_at >= ?', Time.parse(from))
    elsif to.present?
      projects = Project.where('created_at <= ?', Time.parse(to))
    else
      projects = Project.all
    end

    if(id.present? && id != "*")
      projects = projects.where("trader_id = ?", id)
    end

    return projects;
  end
end
