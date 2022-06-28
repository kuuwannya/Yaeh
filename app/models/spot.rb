class Spot < ApplicationRecord
  acts_as_mappable  :default_units => :kms,
                    :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  belongs_to :user
  has_many :post2_spots, dependent: :destroy
  has_many :posts, through: :post2_spots

  #addressのカラムに新規登録や更新処理が走った場合に 自動で緯度経度の情報を新規登録・更新が実施
  #geocoded_by :address
  #after_validation :geocode, if: :address_changed?

  validates :name, presence: true, uniqueness: true
  validates :longitude, presence: true
  validates :latitude, presence: true
  validates :place_id, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
