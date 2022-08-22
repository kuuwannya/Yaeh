class PostsController < ApplicationController
  before_action :post_find, only: %i[destroy edit update]
  skip_before_action :require_login, only: %i[new create edit update destroy]
  def index
    @posts = Post.all.includes(:user, :spots).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.post_spots.build
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      #@post_spot = PostSpot.create(post_id: @post, spot_id: params[:spot_ids])
      @post.spots << post_spots_params[:spot_ids].reject(&:empty?).map{|x| Spot.find(x)}
      binding.pry
      #(@post.spots.count).each.do |spot|
        #spot = Spot.find(spot)
        #pot.update(spot_post_count: Post.where(spot_id: spot.count)
      #end
      redirect_to posts_path, notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit; end

  def update
    if @post.update(update_params)
      redirect_to post_path(@post), notice: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, success: t('.success')
  end

  private
  def post_params
    params.require(:post).permit(:content, :touring_date, { images: [] }).merge(user_id: current_user.id)
  end

  def post_spots_params
    params.require(:post).permit( { spot_ids: [] })
  end

  def update_params
    params.require(:post).permit(:content, :touring_date, { images: [] }, { spot_ids: [] }).merge(user_id: current_user.id)
  end

  def post_find
    @post = current_user.posts.find(params[:id])
  end
end
