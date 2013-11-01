class RootController < ApplicationController
  def index
    @page = Page.roots.find_by_slug 'home'
    @events = Event.where("end_date > ?", DateTime.now).order(:start_date).limit(5)
    contents = []
    Orbiter.all.each do |orb|
        contents.append(:id => orb.id, :content => orb.content)
    end
    @orbits = contents
  end

end
