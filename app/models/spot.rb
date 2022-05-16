class Spot < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :place_id, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
