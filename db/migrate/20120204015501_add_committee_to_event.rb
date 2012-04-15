class AddCommitteeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :committee, :int
  end
end
