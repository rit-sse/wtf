class CreateEventPrices < ActiveRecord::Migration
  def change
    create_table :event_prices do |t|
      t.references :event, null: false
      t.decimal :price, null: false, precision: 8, scale: 2
      t.string :name
      t.timestamps
    end
  end
end
