class DropPostSpot < ActiveRecord::Migration[6.1]
  def change
    drop_table :post_spots
  end
end
