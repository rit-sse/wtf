class User
  attr_accessor :username, :role

  def initialize(options = {})
    options.each_key do |k|
      self.send "#{k}=", options[k] if self.respond_to?("#{k}=")
    end
  end

  def admin?
    @role == "admin" || @role == "officer"
  end
end
