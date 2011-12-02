class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  def authenticate_user!
    # ssedap magic here...
  end

end
