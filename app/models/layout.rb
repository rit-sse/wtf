class Layout

	def self.build_sections(page)
		@section_builders.map do |builder|
			section = builder.call
			section.blocks = page.blocks.select { |b| b.section_key == section.key }
			section
      end
	end

protected

	def self.title(title=nil)
		@title = title unless title.nil?
		@title || self.name.demodulize.titleize
	end

	def self.view(view=nil)
		@view = view unless view.nil?
		@view || "layouts/#{self.name.underscore}"
	end

	def self.section(key)
		@section_builders ||= []
		@section_builders << lambda { Section.new(key) }
	end

end
