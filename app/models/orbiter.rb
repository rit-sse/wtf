
class Orbiter < ActiveRecord::Base
  validates_presence_of :content
  
  def self.make(contents)
    self.create!(:content => contents, :updated_at => Time.now, :created_at => Time.now)
  end
  
  def self.drop_page( sid )
    o = self.where( sid ).first
    if o then o.destroy end
  end
  
  def self.update_content(id, contents)
    orbit = self.where( id ).first
    if orbit then
      orbit[:content] = contents
      orbit[:updated_at] = Time.now
      orbit.save
    else
        self.make(contents)
    end
  end
end
