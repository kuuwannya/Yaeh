class UserSessionsController < ApplicationController
  before_action :require_login, only: :destroy
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to maps_path, success: t('.success')
    else
      flash.now[:danger] =  t('.fail')
      render :new
    end
  end

  def destroy
    current_user.destroy! if current_user.guest?
    logout
    redirect_to root_path, success: t('.success')
  end

  def guest_login
    if current_user
      redirect_to login_path, warnig: "すでにログインしています"
      # ログインしてる場合はユーザーを作成しない
    else
      random_value = SecureRandom.hex
      user = User.create!(name: "Guest", email: "test_#{random_value}@example.com", password: random_value, password_confirmation: random_value, role: :guest)
      auto_login(user)
      redirect_to root_path, success: "ゲストとしてログインしました"
    end
  end
end
