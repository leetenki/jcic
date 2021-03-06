class TradersController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :show, :new, :create, :edit, :update, :destroy, :add_slave, :remove_slave]
  before_action :logged_in, :only => [:my_invoice]

  def index
    @traders = Trader.all.order("id desc")
  end

  def show
    @trader = Trader.find(params[:id])
    if Constants::FAKE_ACCOUNT.include?(@trader.id) and not params[:secret]
        redirect_to traders_path
    else
        @projects = @trader.search_projects(@trader.projects, params[:from], params[:to], params[:payment], params[:confirmation], params[:status], params[:delete_request], params[:ticket_no], params[:japan_company], params[:visa_type]).order("id desc")
    end
  end

  #create account
  def new
    @trader = Trader.new
    @trader.password = [*1..9].sample(8).join;
    @trader.password_backup = @trader.password;
  end

  def create
    @trader = Trader.new(trader_params)
    @trader.password_backup = params[:trader][:password];
    if(params[:trader][:master_id] == "*")
      if(@trader.master_relationship)
        @trader.master_relationship.destroy
      end
    else
      @trader.create_master_relationship(:master_id => params[:trader][:master_id])
    end

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

    if(@trader.master_relationship)
      @trader.master_relationship.destroy
    end

    if(params[:trader][:master_id] == "*")
    else
      @trader.create_master_relationship(:master_id => params[:trader][:master_id])
    end

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

  #relationship manipulation
  def add_slave
    @master = Trader.find_by(:id => params[:master_id])
    @slave = Trader.find_by(:id => params[:slave_id])
    @master.add_slave(@slave)
    flash[:success] = "添加完毕！"
    redirect_to request.referrer || traders_path
  end

  def remove_slave
    @master = Trader.find_by(:id => params[:master_id])
    @slave = @master.slave_relationships.find_by(:id => params[:slave_id])
    @master.remove_slave(@slave)
    flash[:success] = "删除完毕！"
    redirect_to request.referrer || traders_path
  end

  #invoice list page
  def my_invoice
    if(is_admin? || has_authority?)
      @trader = Trader.find_by(:id => params[:id])
      if Constants::FAKE_ACCOUNT.include?(@trader.id) and not params[:secret]
        redirect_to trader_path
      end
    else
      @trader = current_trader
    end
  end

  #common function
  private
  def trader_params
    params.require(:trader).permit(:company_name, :person_name, :telephone, :fax, :email, :qq, :bank, :address, :bank, :password, :account, :password_confirmation, :indivisual_price, :group_price_indivisual, :group_price_1_10, :group_price_11_20, :group_price_21_30, :group_price_31_40, :year_3_price, :year_5_price, :other_price, :group_japan_company, :individual_japan_company, :invoice_company, :invoice_sign_company, :activation, :validation_mode, :guarantee_mode, :work_mode, :authority, :editable_min, :auto_schedule, :china_japan_rate, :bank_type, :money_type)
  end
end
