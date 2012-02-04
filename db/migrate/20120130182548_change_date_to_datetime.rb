class ChangeDateToDatetime < ActiveRecord::Migration
  def up
    remove_column :events, :start_date
    remove_column :events, :end_date
    add_column :events, :start_date, :datetime
    add_column :events, :end_date, :datetime
  end

  def down
    remove_column :events, :start_date
    remove_column :events, :end_date
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
  end
end
