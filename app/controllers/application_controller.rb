class ApplicationController < ActionController::Base
  add_flash_types :warning

  def current_courier
    @current_courier ||= Courier.find(session[:courier_id]) if session[:courier_id]
  end

  def authenticate_delivery_manager!
    if current_delivery_manager && !current_delivery_manager.enabled?
      reset_session
      redirect_to new_delivery_manager_session_path, warning: 'Your profile is disabled'
    end
    super
  end
end
