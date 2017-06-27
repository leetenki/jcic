require 'json'

class Api::VisaController < ApplicationController
  before_action :logged_in_api, :only => [:new, :delete, :check]

  def index
    render :text => current_trader.id
  end

  def code
    result = CompanyCode.where("status = ?", "working").map do |company_code|
      {
        name: company_code.name,
        code: company_code.code
      }
    end
    render json: result
  end

  def delete
    params = JSON.parse(request.body.read, {:symbolize_names => true})
    if(is_admin?)
      @project = Project.find_by(:id => params[:id])
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
      if @project.nil?
        render json: error_message('You have no right to access this visa')
        return
      end
      if(!has_authority? && !is_project_deletable(@project))
        render json: error_message('Failed to delete visa')
        return
      end
    end

    @project.record_timestamps = false
    @project.assign_attributes :delete_request => true
    @project.save :validate => false;
    render json: { id: params[:id], status: 'deleted' }
  rescue JSON::ParserError => e
    render :json => error_message('JSON format incorrect')
  rescue Exception => e
    render :json => error_message(e.message)
  end

  def visa_code
    params = JSON.parse(request.body.read, {:symbolize_names => true})
    project = current_trader.projects.find_by(id: params[:id])
    if project.nil?
      render json: error_message('You have no right to access this visa')
    else
      if project.status == 'committed'
        render json: { visa_code: project.system_code }
      else
        render json: { visa_code: nil }
      end
    end
  rescue JSON::ParserError => e
    render :json => error_message('JSON format incorrect')
  rescue Exception => e
    render :json => error_message(e.message)
  end

  # pdfチェック
  def check
    params = JSON.parse(request.body.read, {:symbolize_names => true})
    project = current_trader.projects.find_by(id: params[:id])
    if project.nil?
      render json: error_message('You have no right to access this visa')
    else
      if project.status == 'committed'
        render json: { pdf: "/projects/#{project.system_code}/report.pdf" }
      else
        render json: { pdf: nil }
      end
    end
  rescue JSON::ParserError => e
    render :json => error_message('JSON format incorrect')
  rescue Exception => e
    render :json => error_message(e.message)
  end

  # 新規レコード作成
  def new
    params = JSON.parse(request.body.read, {:symbolize_names => true})
    result = validate_and_overwrite_params(params[:visa])
    if !result[:valid]
      render json: error_message(result[:error_message]) 
    else
      @project = current_trader.projects.build(params[:visa])
      if @project.valid?
        #custom check doubled visa
        matched_projects = Project.where("trader_id = ? and china_company_name = ? and representative_name_chinese = ? and total_people = ? and visa_type = ? and date_arrival = ? and date_leaving = ?", @project.trader_id, @project.china_company_name, @project.representative_name_chinese, @project.total_people, @project.visa_type, Date.parse(@project.date_arrival.to_s), Date.parse(@project.date_leaving.to_s))
        if(matched_projects.length > 0)
          mached = false
          matched_id = -1
          matched_projects.each do |mached_project|
            if(!mached_project.delete_request && mached_project.status != "deleted" && mached_project.clients[0].passport_no == @project.clients[0].passport_no)
              matched_id = mached_project.id
              mached = true
              break
            end
          end
          if mached
            message = 'Same visa already exists'
            render :json => "{\"message\": \"#{message}\", \"id\": \"#{matched_id}\"}"
            return
          end
        end

        if(@project.check_full_schedule())
          @project.has_full_schedule = true
        end
        dates = params[:visa][:schedules_attributes].values.map do |attr| attr[:date] end
        @project.save
        render :json => { id: @project.id }
      else
        render :json => error_message("#{@project.errors.messages.keys.first.to_s} #{@project.errors.messages.values.first.first.to_s}")
      end
    end
  rescue JSON::ParserError => e
    render :json => error_message('JSON format incorrect')
  rescue Exception => e
    render :json => error_message(e.message)
  end

  # ログイン
  def login
    params = JSON.parse(request.body.read, {:symbolize_names => true})
    @trader = Trader.find_by(:account => params[:account])
    if(@trader && @trader.authenticate(params[:password]))
      if(@trader.activation)
        session[:trader_id] = @trader.id
        session[:updated_at] = Time.now
        render :json => "{ \"token\": \"#{session.id}\" }"
      else
        render error_message('Your account is freezed')
      end
    else
      render :json => error_message('Incorrect account or password')
    end
  rescue JSON::ParserError => e
    render :json => error_message('JSON format incorrect')
  rescue Exception => e
    render :json => error_message('bad request')
  end

  private
  def validate_and_overwrite_params(visa)
    result = {
      valid: false
    }

    # china_code_company
    china_code_company = CompanyCode.find_by(status: "working", code: visa[:china_code].upcase)
    unless china_code_company
      result[:error_message] = "Wrong china_code"
      return result
    end
    visa[:china_company_name] = china_code_company.name
    visa.delete(:china_code)

    # schedules validation
    dates = visa[:schedules_attributes].values.map do |attr| attr[:date] end
    dates.each_with_index do |date, index|
      if Date.parse(date) != Date.parse(visa[:date_arrival]) + index.days
        result[:error_message] = "Wrong date #{date}"
        return result
      end
    end
    if ((Date.parse(visa[:date_leaving]) - Date.parse(visa[:date_arrival])).to_i+1) != visa[:schedules_attributes].size
      result[:error_message] = "Wrong schedules size #{visa[:schedules_attributes].size}"
      return result
    end

    # clients validation
    if visa[:total_people].to_i != visa[:clients_attributes].size
      result[:error_message] = "Wrong clients number #{visa[:total_people]}"
      return result
    end

    result[:valid] = true
    result
  end

  def error_message(message)
    "{\"message\": \"#{message}\"}"
  end
end
