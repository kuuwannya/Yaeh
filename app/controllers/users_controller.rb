class UsersController < ApplicationController
  before_action :user_find, only: %i[show edit update destroy]
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

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
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

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :avatar_cache, :profile)
    end

    def user_find
      @user = User.find(current_user.id)
    end

end
