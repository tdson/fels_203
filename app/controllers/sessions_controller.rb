class SessionsController < ApplicationController
  before_action :not_logged_in, only: [:new, :create]
  before_action :logged_in_user, only: :destroy
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_back_or guest_index_url
    else
      flash.now[:danger] = t ".log_in_fails"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to guest_index_url
  end
end
