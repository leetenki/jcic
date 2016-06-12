class ApiController < ApplicationController
  def translate
  end

  def translate_result
  	 render :text => `phantomjs translate.js #{params[:chinese]}`
  end
end
