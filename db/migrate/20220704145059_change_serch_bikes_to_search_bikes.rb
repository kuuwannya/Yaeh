class ChangeSerchBikesToSearchBikes < ActiveRecord::Migration[6.1]
  def change
    rename_table :serch_bikes, :search_bikes
  end
end
