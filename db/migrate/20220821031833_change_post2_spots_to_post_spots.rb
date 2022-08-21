class ChangePost2SpotsToPostSpots < ActiveRecord::Migration[6.1]
  def change
    rename_table :post2_spots, :post_spots
  end
end
