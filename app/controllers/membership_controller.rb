class MembershipController < ApplicationController
  def index
    puts "whaaaat"
    if params[:q]
      @results = Membership.where(:dce => params[:q])
    end
  end
  
  # GET /committees/new
  # GET /committees/new.json
  def new
    @membership = Membership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @membership }
    end
  end
  
  # POST /committees/new
  # POST /committees/new.json
  def create
    @membership = Membership.new(params[:membership])
    @membership.save
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @membership }
    end
  end
end
