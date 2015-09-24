class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  include SessionsHelper
  include ApplicationHelper

  private 
  def logged_in
    unless logged_in?
      store_location
      flash[:danger] = "您需要会员登录"
      redirect_to login_url
    end
  end

  def logged_in_trader
    unless is_trader?
      store_location
      flash[:danger] = "您需要会员登录"
      redirect_to login_url
    end
  end

  def logged_in_admin
    unless is_admin?
      flash[:danger] = "对不起，您没有权限查看此页"
      redirect_to root_path
    end
  end
end
