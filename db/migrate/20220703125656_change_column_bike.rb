class ChangeColumnBike < ActiveRecord::Migration[6.1]
  def change
    add_index :bikes, :name, unique: true
  end
end
