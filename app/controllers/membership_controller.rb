class MembershipController < ApplicationController
  def index
    if params[:q]
      now = Date.today
      # Membership 'blocks'
      # memberships are good to 2 weeks into the next semester
      # August 20 - (January 27 + 2 weeks)
      # January 27 - (August 20 + 2 weeks)
      jan27 = Date.new(
        now.year,
        1,
        27,
      )
      aug20 = Date.new(
        now.year,
        8,
        20,
      )
      if (now >= jan27 and now <= jan27+2.weeks) 
        @results = Membership.where(dce: params[:q], date: (aug20-1.year)..now)
      elsif (now >= aug20 and now <= aug20+2.weeks)
        @results = Membership.where(dce: params[:q], date: (jan27-1.year)..now)
      elsif (now>=jan27+2.weeks and now<=aug20)
        @results = Membership.where(dce: params[:q], date: jan27..now)
      else
        @results = Membership.where(dce: params[:q], date: aug20..now)
      end
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
    if signed_in?
      @membership = Membership.new(params[:membership])
      @membership.save
    end
    
    respond_to do |format|
      format.html # create.html.erb
      format.json { render json: @membership }
    end
  end
end
