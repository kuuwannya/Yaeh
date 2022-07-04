class CreateSerchBikes < ActiveRecord::Migration[6.1]
  def change
    create_table :serch_bikes do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :bike_gas_mileage
      t.integer :total_distance

      t.timestamps
    end
  end
end
