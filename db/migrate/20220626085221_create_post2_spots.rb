class CreatePost2Spots < ActiveRecord::Migration[6.1]
  def change
    create_table :post2_spots do |t|
      t.references :post, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end

    add_index :post2_spots, [:post_id, :spot_id], unique: true
  end
end
