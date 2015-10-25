class StaticPagesController < ApplicationController
  def home
    redirect_to projects_path
  end

  def browser
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    render "browser", :layout => false;
  end

  def description
    @account = params[:account]
    @password = params[:password]
    @name = params[:name]
  end

  def description_excel
    @account = params[:account]
    @password = params[:password]
    @name = params[:name]
  end
end
