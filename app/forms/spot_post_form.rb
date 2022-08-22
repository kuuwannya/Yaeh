class SpotPostForm
  include ActiveModel::Model # 通常のモデルのようにvalidationなどを使えるようにする
  attr_accessor :content, :touring_date, :user_id, :name, :post_id, :spot_ids


  def save
    post = Post.create(content: content, touring_date: touring_date, user_id: current_user.id)
    spot
  end


end
