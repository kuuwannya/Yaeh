class AddColumnPost < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :spot, foreign_key: true
  end
end
