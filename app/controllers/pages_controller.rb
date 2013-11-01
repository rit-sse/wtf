class PagesController < ApplicationController

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

end
