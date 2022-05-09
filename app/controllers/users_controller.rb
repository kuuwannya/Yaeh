class UsersController < ApplicationController
  before_action :user_find, only: %i[show edit update destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: "ユーザー登録しました"
    else
      flash.now[:danger] = "ユーザー登録できませんでした"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), success: "ユーザーを更新しました"
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :avatar, :avatar_cache, :profile)
    end

    def user_find
      @user = User.find(current_user.id)
    end

end
