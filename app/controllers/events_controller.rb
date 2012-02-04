class EventsController < ApplicationController
  load_and_authorize_resource
  
  # GET /admin/events
  # GET /admin/events.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def public_index
    @events = Event.all

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
