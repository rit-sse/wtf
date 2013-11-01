class CreateOrbiters < ActiveRecord::Migration
  def change
    create_table :orbiters do |t|
      t.string :content
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps
    end
  end
end
