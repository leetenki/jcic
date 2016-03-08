class SessionsController < ApplicationController
  def new
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    if(!@user_agent.browser.match(/Chrome|Firefox|Safari/))
      render '/static_pages/browser', :layout => false
    end
  end

  def create
    @trader = Trader.find_by(:account => params[:session][:account])
    if(@trader && @trader.authenticate(params[:session][:password]))
      if(@trader.activation)
        session[:trader_id] = @trader.id
        session[:updated_at] = Time.now
        flash[:info] = "成功登录#{@trader.company_name}."
        if(is_admin?)
          redirect_to projects_path
        elsif(is_trader?)
          redirect_to projects_path
        end
      else
        flash[:danger] = "对不起，您的账户被冻结，暂时不能使用。"
        render "new"        
      end
    else
      flash[:danger] = "对不起，您的账户与密码不正确。"
      render "new"
    end
  end

  def switch
    if(is_admin?)
      @trader = Trader.find_by(:id => params[:id])
      session[:trader_id] = @trader.id
      flash[:info] = "成功登录#{@trader.company_name}."
      redirect_to projects_path      
    end
  end

  def destroy
    session[:trader_id] = nil
    session[:updated_at] = nil
    redirect_to login_path
  end
end
