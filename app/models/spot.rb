class Spot < ApplicationRecord
  belongs_to :user

  #addressのカラムに新規登録や更新処理が走った場合に 自動で緯度経度の情報を新規登録・更新が実施
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :name, presence: true, uniqueness: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :place_id, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
