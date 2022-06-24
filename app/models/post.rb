class Post < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_many :comments, dependent: :destroy
  has_many_attached :images

  validates :content, length: {maximum: 65_535}, presence: true
  validates :touring_date, presence: true
end
