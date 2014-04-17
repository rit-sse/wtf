class EventsController < AdminController
  skip_before_filter :authenticate!, only: [:public_show, :gtv, :ftv, :current]
  skip_before_filter :authenticate!, only: [:index], if: proc { request.json? or request.ics? or request.csv? }

  load_and_authorize_resource
  skip_authorize_resource only: [:public_show, :gtv, :ftv, :current]

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

    @events = @events.group_by(&:week)
    events_helper
    respond_to do |format|
      format.html
      format.json { render json: @other_events }
      format.ics  { render text: @other_events.to_ical }
      format.csv  { render text: @other_events.to_csv }
    end
  end

  def events_helper
    if params[:start_date] == nil or params[:start_date] == 'now'
      params[:start_date] = DateTime.now
    end
    if params[:limit] == nil
      params[:limit] = 1000
    end

    if params[:can_feature]
      @other_events = Event
        .where(:start_date => Time.now..(7.days.from_now))
        .where(featured: true)
        .order(:start_date)
        .limit(params[:limit])
    else
        if params[:end_date] != nil
            @other_events = Event.where(:start_date => params[:start_date].to_date..params[:end_date].to_date.next_day).order(:start_date).limit(params[:limit])
        else
            @other_events = Event.where(:start_date => params[:start_date].to_date..params[:start_date].to_date.next_month).order(:start_date).limit(params[:limit])
        end
    end
    @featured_events = @other_events.where(featured: true).limit(3)

    if params[:filter] != nil
      committee = Committee.where(:name => params[:filter]).first.id
      @other_events = @other_events.where(:committee_id => committee)
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

    start_date = params[:event].delete(:start_date)
    end_date   = params[:event].delete(:end_date)

    @event = Event.new(params[:event])
    
    @event.start_date = Time.zone.parse(start_date)
    @event.end_date = Time.zone.parse(end_date)



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

    start_date = params[:event].delete(:start_date)
    end_date   = params[:event].delete(:end_date)

    @event.start_date = Time.zone.parse(start_date)
    @event.end_date = Time.zone.parse(end_date)
    @event.save

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

  def ftv
    render :layout => false
  end

  def current
    @event = Event.where("start_date >= ?", DateTime.now.to_date).order("start_date ASC").limit(1).first
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

end
