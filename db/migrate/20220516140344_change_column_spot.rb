class ChangeColumnSpot < ActiveRecord::Migration[6.1]
  def change
    change_column :spots, :longitude, :decimal, precision:  10, scale:  7
    change_column :spots, :latitude, :decimal, precision:  10, scale:  7
    change_column :spots, :rating, :float
  end
end
