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

  protected
  def load_data user
    @activity_log = Activity.user_log(user)
      .paginate page: params[:activity_log_p], per_page: Settings.log_per_page
    @following = user.following.includes(:active_relationships).order_by_name
      .paginate page: params[:followers_p], per_page: Settings.log_per_page
    @followers = user.followers.includes(:active_relationships).order_by_name
      .paginate page: params[:following_p], per_page: Settings.log_per_page
  end
end
