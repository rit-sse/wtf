class ChangeOrbiterStringToText < ActiveRecord::Migration
  def up
  	change_column :orbiters, :content, :text
  end

  def down
  	change_column :orbiters, :content, :string
  end
end
