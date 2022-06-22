class AddColumnSpotId < ActiveRecord::Migration[6.1]
  def change
    add_column :spots, :spot_post_count, :integer
  end
end
