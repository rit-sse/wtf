class RenameCommitteeToCommitteeId < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.rename :committee, :committee_id
	end
  end
end
