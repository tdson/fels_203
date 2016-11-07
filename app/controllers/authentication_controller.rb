class AuthenticationController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = Authorization.sign_in_from_omniauth auth
    if user
      log_in user
      remember user
      redirect_to root_path user and return
    end
    user = Authorization.find_user_by_email auth
    if user
      flash[:info] = t ".email_exists"
      redirect_to login_path and return
    end
    user = User.create_form_auth auth
    if user
      flash[:warning] = t ".warning", pass: Settings.default_password
      log_in user
      remember user
      redirect_to edit_user_path user
    else
      render "sessions/new"
    end
  end
end
