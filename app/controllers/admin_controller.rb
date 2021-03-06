class AdminController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :paid_all, :unpaid_all, :useragent, :get_uncommitted_projects_immediately, :upload_pdf, :renew_company_codes, :update_company_codes, :invoice_internal]
  before_action :initial_search, :only => [:paid_all, :unpaid_all]
  before_action :logged_in, :only => [:invoice, :invoice_excel, :analysis, :create_payoff, :delete_payoff, :create_confirmation, :delete_confirmation, :check_invoice, :activate]

  def index
    if !params[:trader_id].present? && !params[:from].present? && !params[:to].present?
      last_month = Date.today.last_month
      #params[:from] = Date.new(last_month.year, last_month.month, 1).strftime("%Y/%m/%d");
      #params[:to] = Date.new(last_month.year, last_month.month, -1).strftime("%Y/%m/%d");
      params[:from] = Date.today.strftime("%Y/%m/%d");
      params[:to] = (Date.today).strftime("%Y/%m/%d");
      if(current_trader.authority == "all")
        params[:trader_id] = "*"
      elsif(current_trader.authority == "self")
        params[:trader_id] = current_trader.id
      else
        params[:trader_id] = current_trader.authority
      end
      #@waiting = true
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")
    else
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")
    end

    @traders = Trader.where("id <> 1")
  end

  def check_all
    if(not request.remote_ip.in?(Constants::WHITELIST_IP))
        render text: ""
        return
    end

    if !params[:trader_id].present? && !params[:from].present? && !params[:to].present?
      last_month = Date.today.last_month
      #params[:from] = Date.new(last_month.year, last_month.month, 1).strftime("%Y/%m/%d");
      #params[:to] = Date.new(last_month.year, last_month.month, -1).strftime("%Y/%m/%d");
      params[:from] = Date.today.strftime("%Y/%m/%d");
      params[:to] = (Date.today).strftime("%Y/%m/%d");
      params[:trader_id] = "*"
      #@waiting = true
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")
    else
      @projects = search_projects(params[:trader_id], params[:from], params[:to]).order("id desc")
    end

    @traders = Trader.where("id <> 1")
    render "check_all", layout: false
  end

  def paid_all
    @projects.each do |project|
      if(project.payment == "unpaid" && project.status != "deleted" && !project.delete_request)
        project.assign_attributes({:payment => "paid"})
        project.record_timestamps = false
        project.save :validate => false
      end
    end
    flash[:success] = "status == deleted, delete_request == true 以外，所有project的payment转换为paid"
    redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
  end

  def create_payoff
    @trader = Trader.find(params[:trader_id])
    @trader.payoffs.create(status: params[:status])
    redirect_to "/my_invoice/" + params[:trader_id]
  end

  def delete_payoff
    @trader = Trader.find(params[:trader_id])
    @trader.payoffs.find_by(status: params[:status]).delete
    redirect_to "/my_invoice/" + params[:trader_id]
  end

  def create_confirmation
    @trader = Trader.find(params[:trader_id])
    @trader.confirmations.create(status: params[:status])
    redirect_to "/my_invoice/" + params[:trader_id]
  end

  def delete_confirmation
    @trader = Trader.find(params[:trader_id])
    @trader.confirmations.find_by(status: params[:status]).delete
    redirect_to "/my_invoice/" + params[:trader_id]
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

  def check_invoice
    @traders = Trader.where(invoice_company: params[:company] || 'jtg').order(id: :desc)
    @traders = @traders.select do |trader|
      trader.projects.size > 0 and not Constants::NOT_SHOW_TO_JTG_ACCOUNT.include?(trader.id)
    end
  end

  def activate
    @trader = Trader.find(params[:id])
    if @trader.activation
      @trader.update(activation: false)
      flash[:success] = "已停止此账号"
    else
      @trader.update(activation: true)
      flash[:success] = "已开通此账号"
    end

    redirect_to "/admin/check_invoice"
  end

  def invoice_internal
    @traders = Trader.where(invoice_sign_company: ["jcic", "jki"])
  end

  def invoice_excel
    if(is_admin? || has_authority?)
      if !params[:trader_id].present? || !(is_number? params[:trader_id]) || !params[:from].present? || !params[:to].present?
        flash[:danger] = "请正确选择旅行社，开始日期，结束日期。"
        redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
        return
      else
        @trader = Trader.find_by(:id => params[:trader_id])
      end
    else
      #admin以外はparams[:trader_id]を使わない。current_traderを使う
      if !params[:from].present? || !params[:to].present?
        flash[:danger] = "日期不正确。"
        redirect_to "/my_invoice"
        return
      else
        @trader = current_trader
      end
    end

    if params[:include_paid]
      @projects = search_projects(@trader.id, params[:from], params[:to]).order("id asc")   
    else
      @projects = search_projects(@trader.id, params[:from], params[:to]).where("payment = ?", 'unpaid').order("id asc")   
    end

    render "excel", :layout => false;
  end

  def invoice
    if(is_admin? || has_authority?)
      if !params[:trader_id].present? || !(is_number? params[:trader_id]) || !params[:from].present? || !params[:to].present?
        flash[:danger] = "请正确选择旅行社，开始日期，结束日期。"
        redirect_to "/admin?" + URI.encode_www_form([["trader_id", params[:trader_id]], ["from", params[:from]], ["to", params[:to]]])
        return
      else
        @trader = Trader.find_by(:id => params[:trader_id])
      end
    else
      #admin以外はparams[:trader_id]を使わない。current_traderを使う
      if !params[:from].present? || !params[:to].present?
        flash[:danger] = "日期不正确。"
        redirect_to "/my_invoice"
        return
      else
        @trader = current_trader
      end
    end

    if params[:include_paid]
      @projects = search_projects(@trader.id, params[:from], params[:to]).order("id asc")   
    else
      @projects = search_projects(@trader.id, params[:from], params[:to]).where("payment = ?", 'unpaid').order("id asc")   
    end

    html = render_to_string(:template => "/admin/invoice.pdf.erb")
    pdf = PDFKit.new(html, :encoding => "UTF-8"); 
    pdf.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoice.css"
    send_data pdf.to_pdf, :filename => "#{@trader.company_name}账单（#{params[:from]}〜#{params[:to]}）.pdf", :type => "application/pdf", :disposition => "inline"
  end

  ####################### APIs #######################
  def get_project_by_id
    @project = Project.where(:id => params[:id])
    text = @project.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render :text => text;    
  end

  def detail
    @project = Project.find(params[:id])
    if(@project.status == "committed" || @project.status == "deleted")
        render text: "此签证已无需登录，请返回『签证一览』后更新浏览器"
    else
        render "detail", :layout => false;
    end
  end

  def workspace
    # ip restriction
    if(not request.remote_ip.in?(Constants::WHITELIST_IP))
        render text: ""
        return
    end

    @projects = Project.where("status = 'uncommitted' and delete_request = ?", false).order("id asc").includes(:clients, :schedules)
    if(params[:japan_company].present?)
      @projects = @projects.where("japan_company = ?", params[:japan_company])
    end

    if(params[:mode] == "2")
      @projects = @projects.where(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    else
      @projects = @projects.where.not(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    end

    @result = []
    @projects.each do |project| #check if not editable
      if(!is_project_editable(project) and is_project_valid(project))
        if(params[:mode] != "2")
          if(project.id % 2 != params[:mode].to_i)
            next
          end
        end

        @result.push(project)
      end
    end

    text = @result.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render "workspace", :layout => false;
  end

  def get_uncommitted_projects
    @projects = Project.where("status = 'uncommitted' and delete_request = ?", false).order("id asc").includes(:clients, :schedules)
    if(params[:japan_company].present?)
      @projects = @projects.where("japan_company = ?", params[:japan_company])
    end
    if(params[:mode] == "2")
      @projects = @projects.where(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    end

    @result = []
    @projects.each do |project| #check if not editable
      if(!is_project_editable(project) and is_project_valid(project))
        @result.push(project)
      end
    end

    text = @result.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render :text => text;
  end

  def get_committed_waiting_projects
    @projects = Project.where(status: 'committed', pdf: nil, delete_request: false).where("id > 398243 and japan_company = ?", params[:japan_company])
    if(params[:mode] == "2")
      @projects = @projects.where(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    end
    @projects = @projects.order(id: :asc).limit(params[:limit]).includes(:clients, :schedules)

    @result = []
    @projects.each do |project| #check if not editable
      if(!is_project_editable(project) and is_project_valid(project))
        @result.push(project)
      end
    end

    text = @result.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render :text => text;
  end

  def committed_waiting_workspace
    if(not request.remote_ip.in?(Constants::WHITELIST_IP))
        render text: ""
        return
    end

    @projects = Project.where(status: 'committed', pdf: nil, delete_request: false).where("id > 120000 and japan_company = ?", params[:japan_company]).order(id: :asc).limit(params[:limit]).includes(:clients, :schedules)

    if(params[:mode] == "2")
      @projects = @projects.where(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    else
      @projects = @projects.where.not(trader_id: Constants::FAKE_ACCOUNT + Constants::SPECIAL_ACCOUNT)
    end

    @result = []
    @projects.each do |project| #check if not editable
      if(!is_project_editable(project) and is_project_valid(project))
        if(params[:mode] != "2")
          if(project.id % 2 != params[:mode].to_i)
            next
          end
        end

        @result.push(project)
      end
    end

    text = @result.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render "committed_waiting_workspace", :layout => false;
  end

  def get_uncommitted_projects_immediately
    @projects = Project.where("status = 'uncommitted' and delete_request = ?", false).order("id asc").includes(:clients, :schedules)
    if(params[:japan_company].present?)
      @projects = @projects.where("japan_company = ?", params[:japan_company])
    end
    text = @projects.to_json({:include => [:clients, :trader => {:only => [:company_name, :email, :qq]}]})
    render :text => text;
  end

  def set_project_committed
    @project = Project.find(params[:id])
    @project.assign_attributes({:status => "committed", :system_code => params[:system_code]})
    @project.record_timestamps = false
    @project.save :validate => false;
    render :text => "succeeded to update project " + @project.id.to_s
  end

  def renew_company_codes
  end

  def update_company_codes
    company_codes = params[:company_codes].split(/[;\"]{1,}/)
    parsed_company_codes = []
    company_codes.each do |company_code|
      if(company_code.match(/working|stopped/))
        parsed_company_codes.push({
          :code => company_code.split(/[,]/)[0],
          :name => company_code.split(/[,]/)[1],
          :locate => company_code.split(/[,]/)[2],
          :status => company_code.split(/[,]/)[3]
        })
      end
    end

    #update old company_code and add new company_code
    parsed_company_codes.each do |company_code|
      old_company_code = CompanyCode.find_by(:code => company_code[:code])
      if(old_company_code.present?)
        old_company_code.update(:name => company_code[:name], :locate => company_code[:locate], :status => company_code[:status])
      else
        CompanyCode.create(
          :name => company_code[:name],
          :code => company_code[:code],
          :locate => company_code[:locate],
          :memo => "",
          :status => company_code[:status],
          :address => nil,
        );
      end
    end

    #remove old unexist company_code
    CompanyCode.all.each do |old_company_code|
      matched = false
      parsed_company_codes.each do |company_code|
        if company_code[:code] == old_company_code[:code]
          matched = true
          break
        end
      end

      if(!matched)
        old_company_code.update(:status => "stopped")
        #old_company_code.destroy
      end
    end

    #rename doubled company codes
    CompanyCode.rename_doubled_company_codes

    render :text => CompanyCode.all.length;
  end

  def upload_pdf
  end

  def simple_upload_pdf
      @project = Project.find(params[:id])
      @gender_type = {male: 1, female: 2}
      render "simple_upload_pdf", layout: false
  end

  def get_delete_requesting_projects
    @projects = Project.where("delete_request = ? and japan_company = ?", true, params[:japan_company]).order("id asc").includes(:clients, :schedules)    
    text = @projects.to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  def get_delete_requesting_committed_projects
    @projects = Project.where("delete_request = ? and system_code IS NOT NULL and status = 'committed' and japan_company = ?", true, params[:japan_company]).order("id asc").includes(:clients, :schedules)    
    text = @projects.to_json({:include => [:schedules, :clients]})
    render :text => text;
  end

  def set_delete_requesting_projects_deleted
    @projects = Project.where("delete_request = ? and japan_company = ?", true, params[:japan_company]).order("id asc")
    @projects.each do |project|
      project.assign_attributes({:status => "deleted", :delete_request => false})
      project.record_timestamps = false
      project.save :validate => false;
    end
    render :text => "succeeded to delete " + @projects.length.to_s + " projects."
  end

  def analysis
    @traders = Trader.all
    if not params[:secret]
      @traders.each_with_index do |trader, index|
        if Constants::FAKE_ACCOUNT.include?(trader.id)
          @traders = @traders.where("id <> ?", trader.id)
        end
      end
    end
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
      projects = Project.where(created_at: Time.parse(from)..Time.parse(to)+60*60*24-1)
    elsif from.present?
      projects = Project.where('created_at >= ?', Time.parse(from))
    elsif to.present?
      projects = Project.where('created_at <= ?', Time.parse(to) + 60*60*24-1)
    else
      projects = Project.all
    end

    if(id.present?)
      if(id == "*")
      elsif(!(is_number? id))
        @traders = Trader.where(:invoice_company => params[:trader_id])
        @ids = Array.new(0, nil)
        @traders.each do |trader|
          if not is_admin? or not Constants::FAKE_ACCOUNT.include?(trader.id)
            @ids.push(trader.id)
          end
        end
        projects = projects.where("trader_id in (?)", @ids)
      else
        trader = Trader.find_by(:id => id);
        projects = projects.where(:trader_id => trader.slave_trader_ids + [trader.id])
      end
    end

    return projects;
  end

  def is_number? str
    true if Float(str) rescue false
  end  
end
