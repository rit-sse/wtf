class User
  attr_accessible :username, :role

  def initialize(options = {})
    options.each_key do |k|
      self.send "#{k}=", options[k]
    end
  end
end
