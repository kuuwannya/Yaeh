class AddAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :spots, :user, foreign_key: true, null: false
  end
end
