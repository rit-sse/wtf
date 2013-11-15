class Orbiter < ActiveRecord::Base
  attr_accessible :content, :created_at, :updated_at

  validates_presence_of :content

  def self.make(contents)
    self.create!(:content => contents, :updated_at => Time.now, :created_at => Time.now)
  end
  
  def self.drop_page( sid )
    o = self.where( id: sid ).first
    if o then o.destroy end
  end
  
  def self.update_content(id, contents)
    if id=="new" then
        self.make(contents)
        return
    end
    orbit = self.where( id: id ).first
    if orbit then
      orbit[:content] = contents
      orbit[:updated_at] = Time.now
      orbit.save
    else
        self.make(contents)
    end
  end
end
