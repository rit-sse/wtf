class AuthController < ApplicationController
  ssl_exceptions

  def index
    redirect_to admin_events_path if signed_in?
  end

  def authorize
    if Rails.env.development? and
      params[:username] == "admin" and
      params[:password] == "admin"

      set_current_user "admin", "admin"

      redirect_to admin_events_path, notice:"Logged in successfully."
    else
      username = params[:username]
      username = username[/\A\w+/].downcase
      user = username + "@ad.sofse.org"
      psw = params[:password]
      authorized = false

      ldap = Net::LDAP.new :host => Settings.ldap_location,
           :port => 389,
           :auth => {
                 :method => :simple,
                 :username => user,
                 :password => psw
           }

      filter = Net::LDAP::Filter.eq("mail", "*")
      treebase = "OU=Officers,OU=Users,OU=SOFSE,DC=ad,DC=sofse,DC=org"

      officers = []
      ldap.search(:base => treebase, :filter => filter) do |entry|
        officers << entry.mail.first.split("@").first
      end

      if officers.include?(username)
        authorized = true
      end

      error_notice = nil

      if authorized

        username = user
        role = "admin"

        set_current_user username, role
        redirect_to root_path, notice: "Logged in successfully."
      else
        if ldap
          error_notice = "Insufficient Privileges"
        else
          error_notice = "Error: #{ldap.get_operation_result.message}"
        end
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
