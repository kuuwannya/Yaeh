class PostsController < ApplicationController
before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.includes(:user, :spot).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.spot_id = params[:spot_id]
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      @spot_post_count = Spot.find_by(id: post_params[:spot_id])
      @spot_post_count.update(spot_post_count: Post.where(spot_id: post_params[:spot_id]).count)
      redirect_to posts_path, success: t('.success')
    else
      flash.now['danger'] = t('.fail')
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
    if @post.update(post_params)
      redirect_to @post
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
    params.require(:post).permit(:content, :touring_date, :spot_id)
  end

  def find_post
    @post = current_user.posts.find(params[:id])
  end
end
