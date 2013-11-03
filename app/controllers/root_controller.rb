class RootController < ApplicationController
  def index

    # Just grabs the first block and it better be markdown...
    pages = Page.where(slug: "home").first
    @page = pages.sections.first.blocks.first

    @events = Event.where("end_date > ?", DateTime.now).order(:start_date).limit(5)
    contents = []
    Orbiter.all.each do |orb|
        contents.append(:id => orb.id, :content => orb.content)
    end
    @orbits = contents
  end

end
