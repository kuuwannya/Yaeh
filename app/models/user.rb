class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :spots
  has_many :posts
  has_many :comments, dependent: :destroy

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true, length: { maximum: 255}

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general:0, admin:1, guest:2 }

  def own?(object)
    object.user_id == id
  end
end
