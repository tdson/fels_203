class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper

  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "application.warning_login"
      redirect_to login_url
    end
  end

  def verify_admin
    redirect_to root_path unless admin?
  end
end
