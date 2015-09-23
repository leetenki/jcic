class SessionsController < ApplicationController
  def new
  end

  def create
    @trader = Trader.find_by(:account => params[:session][:account])
    if(@trader && @trader.authenticate(params[:session][:password]))
      session[:trader_id] = @trader.id
      flash[:info] = "#{@trader.company_name} #{@trader.person_name} 欢迎您登录飞鹤旅签证网！"
      if(is_admin?)
        redirect_to projects_path
      elsif(is_trader?)
        redirect_to projects_path
      end
    else
      flash[:danger] = "对不起，您的账户与密码不正确。"
      render "new"
    end
  end

  def destroy
    session[:trader_id] = nil
    redirect_to login_path
  end
end
