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
      user = params[:username]
      user = user[/\A\w+/].downcase
      user << "@ad.sofse.org"
      psw = params[:password]

      ldap = Net::LDAP.new(
        host: Settings.ldap_location,         
        auth: { username: user, password: psw }
      )
      ldap.port = 636
      ldap.encryption(:simple_tls)

      result = ldap.bind

      if result
        ldap.search(
          base:         "DC=ad,DC=sofse,DC=org",
          filter:       Net::LDAP::Filter.eq( "mail", user ),
          attributes:   %w[ displayName ],
          return_result:true
        ) do | entry |
          p "="*80
          entry.each do |attribute, values|
            puts "   #{attribute}:"
            values.each do |value|
              puts "      --->#{value}"
            end
          end
          p "="*80
        end
      end

      error_notice = nil

      if result

        username = user
        role = "admin"

        set_current_user username, role
        redirect_to root_path, notice: "Logged in successfully."
      else
        error_notice = "Error: #{ldap.get_operation_result.message}"
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
