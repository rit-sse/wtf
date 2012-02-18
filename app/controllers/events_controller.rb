class EventsController < AdminController
  skip_before_filter :authenticate!, :only => [:public_index, :public_show, :gtv]

  load_and_authorize_resource
  skip_authorize_resource :only => [:public_index, :public_show, :gtv ]

  # GET /admin/events
  # GET /admin/events.json
  def index
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

    if params[:end_date] != nil
      @events = Event.limit(params[:limit]).where(:start_date => params[:start_date].to_date..params[:end_date].to_date.next_day)
    else
      @events = Event.limit(params[:limit]).where(:start_date => params[:start_date].to_date..params[:start_date].to_date.next_month)
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
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    #@event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def public_show
    #@event = Event.find(params[:id])
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
    #@event = Event.find(params[:id])
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
    #@event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
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
    #@event = Event.find(params[:id])
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
