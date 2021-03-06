class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize!

  add_flash_types :success, :info, :warning, :danger

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_permission
    @current_permission ||= PermissionsService.new(current_user)
  end

  def authorize!
    unless authorized?
      redirect_to root_url, danger:  "Danger Will Robinson"
    end
  end

  def authorized?
    current_permission.allow?(params[:controller], params[:action])
  end
end
