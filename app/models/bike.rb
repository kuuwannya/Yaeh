class Bike < ApplicationRecord
  has_many :search_bikes, dependent: :destroy
  has_many :user, through: :search_bikes

  validates :name, presence: true
  validates :name, uniqueness: true

end
