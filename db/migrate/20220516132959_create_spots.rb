class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.string :name, null: false
      t.integer :longitude, null: false
      t.integer :latitude, null: false
      t.string :image
      t.string :address, null: false
      t.string :prefecture, null:false
      t.string :opening_at
      t.string :regular_holiday
      t.integer :tel_number
      t.integer :rating
      t.string :place_id, null: false
      t.string :spot_parking
      t.string :spot_parking_price

      t.timestamps
    end
  end
end
