class AuthController < ApplicationController
  def index
    redirect_to root_path if signed_in?
  end
  
  def authorize
    if Rails.env.development? and
      params[:username] == "admin" and
      params[:password] == "admin"

      set_current_user "admin", "admin"

      redirect_to root_path, notice:"Logged in successfully."
    else

      client = SSEDAP::Client.new "http://ssedap.dev"
      auth_hash = client.authorize params[:username], params[:password]
      logger.debug auth_hash
      
      if auth_hash["data"]["success"]
        username = auth_hash["data"]["user"]
        role = auth_hash["data"]["user_info"]["role"]
        set_current_user username, role
        
        redirect_to root_path, notice: "Logged in successfully."
      else
        flash[:notice] = "Error: #{auth_hash["data"]["error"]}"
        render :index
      end
    end
  end
  
  def logout
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end
end
