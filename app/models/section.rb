class Section
	attr_reader :key, :title
	attr_accessor :blocks

	def initialize(key)
		begin
			@key = key.to_sym
	    rescue NoMethodError
			raise Error.new("Container key must be a symbol")
		end

		@title = key.to_s.humanize.titlecase
		@blocks = []
	end

	def valid_blocks
		@blocks.select(&:valid?)
	end
end
