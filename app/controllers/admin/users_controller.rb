class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_user, only: :destroy

  def index
    @users = User.search_name_or_email(params[:q]).order_by_name
      .paginate page: params[:page], per_page: Settings.admin.user_per_page
  end

  def destroy
    if @user.destroy
      flash[:success] = t "admin.delete.success", resource: t(".resource")
    else
      flash[:danger] = t "admin.delete.fails", resource: t(".resource").downcase
    end
    redirect_to admin_users_path
  end

  private
  def load_user
    @user = User.find_by_id params[:id]
    unless @user
      flash[:danger] = t "admin.load_fails.user"
      redirect_to admin_users_path
    end
  end
end
