class MovePagesToBlocks < ActiveRecord::Migration
  def up
  	# Go through all pages and move their content into a
  	# markdown block associated with the page.
  	Page.all.each do |page|
  		if not page.content.nil?
  			block = Markdown.new
  			block.page_id = page.id
  			block.section_key = 'content'
  			block.content = page.content

  			block.save!
  		end
  	end
  end

  def down
  end
end
