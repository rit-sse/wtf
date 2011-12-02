class AdminController < ApplicationController
  before_filter :authenticate

  def index
  end

protected

  def authenticate
    authenticate_user!
  end

end
