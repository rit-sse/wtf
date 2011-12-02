class ChangePagesNameToTitle < ActiveRecord::Migration
  def up
    rename_column :pages, :name, :title
  end

  def down
  end
end
