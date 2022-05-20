class UserSessionsController < ApplicationController
  before_action :require_login, only: :destroy
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: t('.success')
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
end
