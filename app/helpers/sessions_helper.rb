module SessionsHelper
  #trader
  def current_trader
    @current_trader = @current_trader || Trader.find_by(:id => session[:trader_id])
  end

  def logged_in?
    !!current_trader
  end

  def is_admin?
    return (logged_in? && current_trader.id == 1)
  end

  def is_trader?
    return (logged_in? && current_trader.id != 1)
  end

  def store_location
    if request.get?
      session[:forwarding_url] = request.url
    end
  end
end