class UsersController < ApplicationController
  before_action :user_find, only: %i[destroy withdrawal edit update]
  skip_before_action :require_login, only: %i[new create edit update destroy]
  def new
    @user = User.new
    @user.users_bikes.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: t('.success')
    else
      flash.now[:danger] =  t('.fail')
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @bike = @user.bikes
  end

  def edit
    @bikes = Bike.all
  end

  def update
    if @user.update(update_params)
      redirect_to user_path(@user), notice: t('.success')
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
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end

    def user_find
      @user = User.find(current_user.id)
    end

    def update_params
      params.require(:user).permit(:name, :email, :avatar, :profile, { bike_ids: []})
    end

end
