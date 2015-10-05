class StaticPagesController < ApplicationController
  def home
    redirect_to projects_path
  end

  def browser
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    render "browser", :layout => false;
  end
end
