class TradersController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  #before_action :logged_in_trader , :only => [:show]

  def index
    @traders = Trader.all.order("id desc")
  end

  def show
    @trader = Trader.find(params[:id])
    @projects = @trader.search_projects(@trader.projects, params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no]).order("id desc")
  end

  #create account
  def new
    @trader = Trader.new
  end

  def create
    @trader = Trader.new(trader_params)
    @trader.password_backup = params[:trader][:password];
    if @trader.save
      flash[:success] = "成功注册新账户!"
      redirect_to @trader
    else
      render 'new'
    end
  end

  #update account
  def edit
    @trader = Trader.find(params[:id])
    @trader.password = @trader.password_backup
    @trader.password_confirmation = @trader.password_backup
  end

  def update
    @trader = Trader.find_by(:id => params[:id])
    @trader.password_backup = params[:trader][:password]
    if @trader.update(trader_params)
      flash[:success] = "成功编辑账户!"
      redirect_to traders_path
    else
      render 'edit'
    end
  end

  #delete account
  def destroy
    @trader = Trader.find_by(:id => params[:id])
    if (@trader.nil? || @trader.id == 1)
      flash[:danger] = "对不起，不可删除此帐户！"
    else
      @trader.destroy
      flash[:success] = "成功删除账户！"
    end

    redirect_to traders_path
  end

  #common function
  private
  def trader_params
    params.require(:trader).permit(:company_name, :person_name, :telephone, :fax, :email, :qq, :bank, :address, :bank, :password, :account, :password_confirmation)
  end
end
