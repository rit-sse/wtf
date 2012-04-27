class CommitteesController < ApplicationController
  # GET /committees
  # GET /committees.json
  def index
    @committees = Committee.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @committees }
    end
  end

  # GET /committees/1
  # GET /committees/1.json
  def show
    @committee = Committee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @committee }
    end
  end

  # GET /committees/new
  # GET /committees/new.json
  def new
    @committee = Committee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @committee }
    end
  end

  # GET /committees/1/edit
  def edit
    @committee = Committee.find(params[:id])
  end

  # POST /committees
  # POST /committees.json
  def create
    @committee = Committee.new(params[:committee])

    respond_to do |format|
      if @committee.save
        format.html { redirect_to @committee, notice: 'Committee was successfully created.' }
        format.json { render json: @committee, status: :created, location: @committee }
      else
        format.html { render action: "new" }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /committees/1
  # PUT /committees/1.json
  def update
    @committee = Committee.find(params[:id])

    respond_to do |format|
      if @committee.update_attributes(params[:committee])
        format.html { redirect_to @committee, notice: 'Committee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committees/1
  # DELETE /committees/1.json
  def destroy
    @committee = Committee.find(params[:id])
    @committee.destroy

    respond_to do |format|
      format.html { redirect_to committees_url }
      format.json { head :no_content }
    end
  end
end
