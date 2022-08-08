class ChangeSearchBikesToUsersBikes < ActiveRecord::Migration[6.1]
  def change
    rename_table :search_bikes, :users_bikes
  end
end
