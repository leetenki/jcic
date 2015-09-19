require 'chinese_converter'
include ChineseConverter

class CompanyCodesController < ApplicationController
  before_action :logged_in_admin, :only => [:index, :edit, :update]

  def index
    @company_codes = CompanyCode.all
    @company_codes.each do |c|
      c.search_text = c.code+ChineseConverter.simplized(c.locate+c.name)
    end
  end

  #edit and update
  def edit
    @company_code = CompanyCode.find_by(:id => params[:id])
  end

  def update
    @company_code = CompanyCode.find_by(:id => params[:id])
    if @company_code.update(company_code_params)
      flash[:success] = "旅行社资料更新完毕！"
      redirect_to company_codes_path
    elsif
      render 'edit'
    end
  end

  private
  def company_code_params
    params.require(:company_code).permit(:name, :code, :memo, :status, :locate, :address)
  end
end
