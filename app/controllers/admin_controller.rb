class AdminController < ApplicationController
  before_action :logged_in_admin, :only => [:projects_need_update, :project_json]

  def projects_need_update
    text = Project.all.to_json({:only => [:clients => [:id]] })
    render :text => text;
  end

  def project_json
    text = Project.find_by(:id => params[:id]).to_json({:include => [:schedules, :clients]})
    render :text => text;
  end
end