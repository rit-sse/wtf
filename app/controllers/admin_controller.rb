class AdminController < ApplicationController
  before_filter :authenticate!

  def index
  end
end
