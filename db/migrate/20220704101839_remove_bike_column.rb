class RemoveBikeColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :bikes, :bike_gas_mileage, :integer
    remove_column :bikes, :total_distance, :integer
  end
end
