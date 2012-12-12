class PagesController < AdminController
  ssl_exceptions :dynamic_page
  skip_before_filter :authenticate!, only: [:dynamic_page]

  load_and_authorize_resource
  skip_authorize_resource only: [:dynamic_page]

  def dynamic_page
    # lowercase because mongo finds are case-sensitive, and we store slugs
    # in lowercase
    path = params[:path].downcase
    components = path.split '/'

    @page = nil
    components.each do |c|
      pages = @page.nil? ? Page.where(slug: c).to_a.select { |p| p.parent_id.nil? } : @page.children.where(slug: c)
      @page = pages.first
      break if @page.nil?
    end

    if @page.nil?
      # 404!
      render template: "/pages/404", status: 404
    else
      render template: @page.layout.view
    end
  end

  # GET /pages
  # GET /pages.json
  def index
    @pages = @pages.roots.order("title")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new
    @page.parent = Page.find(params[:parent_id]) unless params[:parent_id].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to pages_path, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to pages_path, notice: 'Page was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_path, notice: "Page successfully destroyed." }
      format.json { head :ok }
    end
  end

end
