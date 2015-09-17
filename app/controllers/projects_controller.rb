class ProjectsController < ApplicationController
  before_action :logged_in, :only => [:create, :index]

  def create
    @project = current_trader.projects.build(project_params)
    if(@project.save)
      flash[:success] = "Add #{@project.china_company_name} #{@project.china_company_code} to list"
      redirect_to projects_path
    else
      @projects = current_trader.projects
      render 'projects/index'
    end
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
