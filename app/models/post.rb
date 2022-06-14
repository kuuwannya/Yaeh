class Post < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_many :comments, dependent: :destroy

  validates :content, length: {maximum: 65_535}, presence: true
  validates :touring_date, presence: true
end
