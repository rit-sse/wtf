class RemoveAuthorIdFromPages < ActiveRecord::Migration
  def up
    remove_column :pages, :author_id
  end

  def down
    add_column :pages, :author_id, :integer
  end
end
