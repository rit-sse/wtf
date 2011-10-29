class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :slug
      t.integer :author_id
      t.datetime :published_at
      t.text :content

      t.timestamps
    end
  end
end
