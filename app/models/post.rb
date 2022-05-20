class Post < ApplicationRecord
  belongs_to :user
  has_many :post_spots
  has_many :spots, through: :post_spots
  accepts_nested_attributes_for :post_spots
  has_many :comments, dependent: :destroy

  validates :content, length: {maximum: 65_535}, presence: true
  validates :touring_date, presence: true
end
