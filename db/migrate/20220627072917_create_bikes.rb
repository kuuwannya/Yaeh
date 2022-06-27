class CreateBikes < ActiveRecord::Migration[6.1]
  def change
    create_table :bikes do |t|
      t.string :name, null:false
      t.integer :bike_gas_mileage, null:false
      t.integer :total_distance

      t.timestamps
    end
  end
end
