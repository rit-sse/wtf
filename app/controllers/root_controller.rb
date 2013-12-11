class RootController < ApplicationController

  ssl_allowed :index

  def index

    if signed_in? and Rails.env.production?
	if not request.ssl?
          redirect_to :protocol => 'https://', 
                      :controller => 'root', 
                      :action => 'index'
	end
    end

    # Just grabs the first block and it better be markdown...
    pages = Page.where(slug: "home").first
    if pages # For when the database is empty. Like on development.
        @page = pages.sections.first.blocks.first
    end
        
    @events = Event.where("end_date > ?", DateTime.now).order(:start_date).limit(5)
    contents = []
    Orbiter.all.each do |orb|
        contents.append(:id => orb.id, :content => orb.content)
    end
    @orbits = contents
  end

end
