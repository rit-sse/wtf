class ApplicationController < ActionController::Base
  protect_from_forgery

  include ::SslRequirement

  helper_method :current_user
  helper_method :signed_in?

  if Rails.env.production?
    rescue_from Exception do |exc|
      Rails.logger.error "Exception: #{exc}, backtrace:\n#{exc.backtrace}"
      render file: "public/500.html", layout: nil
    end
  end

  protected

  def current_user
    unless session[:user].nil?
      @current_user ||= session[:user]
    end

    @current_user
  end

  def set_current_user(username, role)
    user = User.new username: username, role: role
    session[:user] = user
    Rails.logger.debug "#{role}: #{user.role}"
    @current_user = user
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
