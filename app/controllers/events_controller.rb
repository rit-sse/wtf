class EventsController < AdminController
  skip_before_filter :authenticate!, :only => [:public_index, :public_show, :gtv]

  load_and_authorize_resource
  skip_authorize_resource only: [:public_index, :public_show, :gtv]

  # GET /admin/events
  # GET /admin/events.json
  def index
    if params[:when] and params[:when] == "past"
      # Past events are sorted in "most recent -> oldest" order
      @events = Event.where("start_date <  ?", DateTime.now.to_date).order("start_date DESC")
      @when = :past
    elsif params[:when] and params[:when] == "all"
      # All events are ordered in "most in the future -> oldest" order
      @events = Event.order("start_date DESC").all
      @when = :all
    else
      # Future events are ordered in "soonest -> furthest away" order
      @events = Event.where("start_date >= ?", DateTime.now.to_date).order("start_date ASC")
      @when = :future
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def public_index
    if params[:start_date] == nil or params[:start_date] == 'now'
      params[:start_date] = DateTime.now
    end
    if params[:limit] == nil
      params[:limit] = 1000
    end
    
    if params[:can_feature]
      @events = Event.where(:start_date => params[:start_date].to_date..params[:start_date].to_date.next_week).order(:start_date).limit(params[:limit])
    else 
        if params[:end_date] != nil
            @events = Event.where(:start_date => params[:start_date].to_date..params[:end_date].to_date.next_day).order(:start_date).limit(params[:limit])
        else
            @events = Event.where(:start_date => params[:start_date].to_date..params[:start_date].to_date.next_month).order(:start_date).limit(params[:limit])
        end
    end

    if params[:filter] != nil
      committee = Committee.where(:name => params[:filter]).first.id
      @events = @events.where(:committee_id => committee)
    end

    respond_to do |format|
      format.html do # index.html.erb
        if params[:view] == "calendar"
          render :index_calendar
        else
          render :public_index
        end
      end
      format.json { render json: @events }
      format.ics  { render :text => Event.to_ical }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def public_show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /admin/events/new
  # GET /admin/events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /admin/events/1/edit
  def edit
  end

  # POST /admin/events
  # POST /admin/events.json
  def create
    puts params[:event]
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/events/1
  # PUT /admin/events/1.json
  def update
    # If there is a paramater named "when", it means we were
    # previously in an edit view which we traveled to from 
    # one of the tabs from the edit view home page.
    # These tabs (and the values of when): future, past, all

    # Example: I traveled from the past events view to edit an event
    # when will be "past", and I should redirect the user back to the
    # "past" event list
    events_when_params = {}
    if params[:when]
      events_when_params[:when] = params[:when]
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to events_path(events_when_params), notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/events/1
  # DELETE /admin/events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end

  # No JSON
  def gtv
    render :layout => false
  end

end
