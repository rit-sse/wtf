class RootController < ApplicationController

  ssl_required :index if signed_in?

  def index

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
