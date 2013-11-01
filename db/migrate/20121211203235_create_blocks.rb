class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references :page, null: false
      t.string :section_key, null: false
      t.string :type, null: false
      t.string :content
      t.string :extra_attributes

      t.timestamps
    end
  end
end
