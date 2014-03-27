class RootController < ApplicationController

  ssl_allowed :index

  def index
    redirect_to admin_events_path if signed_in?
  end

end
