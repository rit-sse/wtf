class AddContentTypeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :content_type, :string
  end
end
