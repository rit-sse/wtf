class Page < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  
  has_ancestry
end
