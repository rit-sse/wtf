class RootController < ApplicationController
  def index
    @page = Page.roots.find_by_slug 'home'
  end

end
