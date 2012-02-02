class AdminController < ApplicationController
  ssl_exceptions
  before_filter :authenticate!

  def index
  end
end
