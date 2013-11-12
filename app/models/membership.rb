class Membership < ActiveRecord::Base
  attr_accessible :date, :dce, :first_name, :last_name, :reason
  
  validates_presence_of :dce, :first_name, :last_name, :date
end
