class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :dce
      t.string :first_name
      t.string :last_name
      t.text :reason
      t.date :date

      t.timestamps
    end
  end
end
