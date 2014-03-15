class AddLayoutToPages < ActiveRecord::Migration
  def up
  	add_column :pages, :layout, :string

  	# Make all current pages use the single column layout
  	# Page.reset_column_information
  	# Page.all.each do |page|
  	# 	page.update_attributes!(:layout => 'single_column')
  	# 	page.save!
  	# end

  	# Make the layout column a required field
  	change_column :pages, :layout, :string, :null => false
  end

  def down
  	remove_column :pages, :layout
  end
end
