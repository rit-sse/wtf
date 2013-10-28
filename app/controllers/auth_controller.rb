class AuthController < ApplicationController
  ssl_exceptions

  def index
    redirect_to root_path if signed_in?
  end

  def authorize
    # if Rails.env.development? and
    #   params[:username] == "admin" and
    #   params[:password] == "admin"

    #   set_current_user "admin", "admin"

    #   redirect_to root_path, notice:"Logged in successfully."
    # else
    if true
      user = params[:username] + "@ad.sofse.org"
      psw = params[:password]

      ldap = Net::LDAP.new
      ldap.host = 'dc1.ad.sofse.org'

      result = ldap.bind(:method => :simple, :username => user, :password => psw)

      p "="*80
      p result
      p "="*80

      error_notice = nil

      if result

        username = user
        role = "admin"

        set_current_user username, role
        redirect_to root_path, notice: "Logged in successfully."
      else
        error_notice = "Error: #{ldap.get_operation_result}"
      end

      if error_notice
        flash[:error] = error_notice
        render :index
      end
    end
  end

  def logout
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end
end
