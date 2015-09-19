require 'chinese_converter'
include ChineseConverter

class ProjectsController < ApplicationController
  before_action :logged_in, :only => [:new, :create, :index]

  #create new project
  def new
    @project = current_trader.projects.build
    @company_codes = CompanyCode.where("status = ?", "working")
    @company_codes.each do |c|
      c.search_text = c.code+ChineseConverter.simplized(c.locate+c.name)
    end
  end

  def create
    @project = current_trader.projects.build(project_params)
    #@project.valid?
    #render :text => @project.errors.messages 

    render :text => params;
=begin
    if(@project.save)
      flash[:success] = "电子签证申请完毕，请再次检查. 1工作日之内将发行签证."
      redirect_to projects_path
    else
      @company_codes = CompanyCode.where("status = ?", "working")
      @company_codes.each do |c|
        c.search_text = c.code+ChineseConverter.simplized(c.locate+c.name)
      end
      render 'new'
    end
=end
  end

  def index
    if logged_in?
      @project = current_trader.projects.build
      @projects = current_trader.projects
    end
  end

  private
  def project_params
    params.require(:project).permit(:china_company_name, :china_company_code, :visa_type, :total_people, :representative_name_english, :representative_name_chinese, :date_arrival, :date_leaving)
  end
end
