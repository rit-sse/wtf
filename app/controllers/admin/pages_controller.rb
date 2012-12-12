module Admin
  class PagesController < AdminController

    load_and_authorize_resource

    # GET /admin/pages/new
    def new
      @page = Page.new
      @page.parent = Page.find(params[:parent_id]) unless params[:parent_id].nil?
    end

    # GET /admin/pages/1/edit
    def edit
    end

    # POST /admin/pages
    def create
      @page = Page.new(params[:page])

      if @page.save
        redirect_to admin_pages_path, notice: 'Page was successfully created.'
      else
        render action: "new"
      end
    end

    # PUT /admin/pages/1
    def update
      if @page.update_attributes(params[:page])
        redirect_to pages_path, notice: 'Page was successfully updated.'
      else
        render action: "edit"
     end
    end

    # DELETE /admin/pages/1
    def destroy
      @page.destroy

      redirect_to admin_pages_path, notice: "Page successfully destroyed."
    end

  end
end
