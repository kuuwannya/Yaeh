class CreatePostSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :post_spots do |t|
      t.references :post, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
      t.index [:spot_id, :post_id], unique: true
    end
  end
end
