module SessionsHelper
  #trader
  def current_trader
    if(!session[:updated_at].nil? && session[:updated_at] + 3600 * Constants::LOGIN_TIMEOUT_HOUR > Time.now)
      @current_trader = @current_trader || Trader.find_by(:id => session[:trader_id])
      session[:updated_at] = Time.now
    else
      session[:trader_id] = nil
      session[:updated_at] = nil
    end

    return @current_trader
  end

  def logged_in?
    if(!!current_trader && current_trader.activation)
      return true
    else
      return false
    end
  end

  def is_admin?
    return (logged_in? && current_trader.id == 1)
  end

  def is_trader?
    return (logged_in? && current_trader.id != 1)
  end

  # has view authority
  def has_authority?
    return current_trader.authority != "self"
  end

  def store_location
    if request.get?
      session[:forwarding_url] = request.url
    end
  end
end