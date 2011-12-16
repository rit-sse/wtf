class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :signed_in?

  protected

  def current_user
    unless session[:username].nil? and session[:role].nil?
      @current_user ||= { username: session[:username], role: session[:role] }
    else
      nil
    end
  end

  def set_current_user(username, role)
    session[:username] = username
    session[:role] = role
    current_user
  end
  
  def signed_in?
    true unless current_user.nil?
  end

  def authenticate!
    unless current_user
      redirect_to auth_path
    end
  end
end
