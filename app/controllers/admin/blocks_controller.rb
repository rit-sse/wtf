module Admin
  class BlocksController < AdminController

    load_and_authorize_resource

    def new
      @page = Page.find(params[:page_id])

      @block = Kernel.const_get(params[:type]).new
      @block.page = @page
      @block.section_key = params[:section_key]

      render action: "show", layout: false
    end

  end
end
