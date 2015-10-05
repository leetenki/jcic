class AdminController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :paid_all, :unpaid_all, :invoice, :useragent, :projects_need_update, :project_json]
  before_action :initial_search, :only => [:paid_all, :unpaid_all]

  def index
    if !params[:trader_id].present? && !params[:from].present? && !params[:to].present?
      last_month = Date.today.last_month
      params[:from] = Date.new(last_month.year, last_month.month, 1).strftime("%Y/%m/%d");
      params[:to] = Date.new(last_month.year, last_month.month, -1).strftime("%Y/%m/%d");
      @waiting = true
    else
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")
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

  def projects_need_update
    text = Project.all.to_json({:only => [:clients => [:id]] })
    render :text => text;
  end

  def project_json
    text = Project.find_by(:id => params[:id]).to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  #action to testing and detect user agent
  def useragent    
  end


private
  def initial_search
    @traders = Trader.where("id <> 1")
    @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")   
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
