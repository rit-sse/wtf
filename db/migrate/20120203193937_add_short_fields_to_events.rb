class AddShortFieldsToEvents < ActiveRecord::Migration

  def up
    add_column :events, :short_name, :string
    add_column :events, :short_description, :string
  end

  def down
    remove_column :events, :short_name
    remove_column :events, :short_description
  end

end
