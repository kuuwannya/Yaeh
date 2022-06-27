class DeleteSpotId < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :spot_id
  end
end
