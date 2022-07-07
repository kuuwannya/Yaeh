class UsersBike
  include ActiveModel::Model
  # include ActiveModel::Modelを記述することでFromオブジェクトを作る
  attr_accessor :name, :email, :avatar, :profile, :bike_name
# ゲッターとセッターの役割両方できる仮想的な属性を作成

# :nameとかt保存したいカラムを書けば、保存できるって理解でまずはok

  with_options presence: true do
    validates :name
    validates :email
    validates :avatar
    validates :profile
    validates :bike_name
  end

  def save
    user = User.create(name: name, email: email, avatar: avatar, profile: profile)
  end

  def update
    @user = User.where(id: user_id)
    user = @user.update(name: name, email: email, avatar: avatar, profile: profile)
    bike = Bike.where(name: bike_name)
    bike.save

    SearchBike.create(user_id: user.id, bike_id: bike.id)
  end
end
