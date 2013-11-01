class RemoveContentFromPages < ActiveRecord::Migration
  def up
  	remove_column :pages, :content
  	remove_column :pages, :content_type
  end

  def down
  	add_column :pages, :content, :text
  	add_column :pages, :content_type, :string
  end
end
