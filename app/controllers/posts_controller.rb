class PostsController < ApplicationController
before_action :find_post, only: [:edit, :update, :destroy]
  def index
    @posts = Post.all.includes(:user, :spots).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @spots = @post.spots
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      #flash.now['danger'] = t('defaults.message.not_updated', item: Board.model_name.human)
      render :edit
    end
  end

  def destroy
    @board.destroy!
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:content, :touring_date)
  end

  def find_post
    @post = current_user.posts.find(params[:id])
  end
end
