class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger, :info, :warning

  private
    def not_authenticated
      flash[:warning] = 'ログインしてください'
      redirect_to main_app.login_path
    end
end
