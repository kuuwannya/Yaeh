class Bike < ApplicationRecord
  has_many :users_bikes, dependent: :destroy
  has_many :user, through: :users_bikes

  validates :name, presence: true
  validates :name, uniqueness: true

end
