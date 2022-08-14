class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :spots, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users_bikes, dependent: :destroy
  has_many :bikes, through: :users_bikes
  accepts_nested_attributes_for :users_bikes, allow_destroy: true
  accepts_nested_attributes_for :bikes

  has_one_attached :avatar
  has_one_attached :header

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true, length: { maximum: 255}

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  enum role: { general:0, admin:1, guest:2 }

  def own?(object)
    object.user_id == id
  end
end
