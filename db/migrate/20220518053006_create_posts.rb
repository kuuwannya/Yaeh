class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :content, null: false
      t.string :route_image
      t.float :route_total_distance
      t.float :route_gas_mileage
      t.datetime :touring_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
