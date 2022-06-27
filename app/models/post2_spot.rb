class Post2Spot < ApplicationRecord
  belongs_to :post
  belongs_to :spot
  validates :post_id, presence: true
  validates :spot_id, presence: true
end
