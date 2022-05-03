class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :name,             null: false
      t.string :avatar
      t.text :profile
      t.integer :role,            null: false, default: 0


      t.timestamps                null: false
    end
  end
end
