class ApplicationController < ActionController::Base
  def current_courier
    @current_courier ||= Courier.find(session[:courier_id]) if session[:courier_id]
  end
end
