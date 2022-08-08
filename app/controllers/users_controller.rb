class UsersController < ApplicationController
  before_action :user_find, only: %i[edit update destroy withdrawal]
  skip_before_action :require_login, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] =  t('.fail')
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @bikes = Bike.all
  end

  def update
    @user = UsersBike.new
    if @user.update(update_params)
      redirect_to user_path(@user), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path, success: t('.success')
  end

  def withdrawal; end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :profile)
    end

    def user_find
      @user = User.find(current_user.id)
    end

    def update_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :profile, :bike_name).merge(user_id: current_user.id)
    end

end
