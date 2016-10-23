class UsersController < ApplicationController
  before_action :not_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".success"
      log_in @user
      redirect_to root_url
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
  end
end
