class UsersController < ApplicationController
  before_action :not_logged_in, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :show]

  def index
    @users = User.order_by_name.paginate page: params[:page],
      per_page: Settings.user_per_page
  end

  def show
    @user = User.find_by_id params[:id]
    if @user
      @followers_size = @user.followers.size
      @following_size = @user.following.size
      @user_result_ids = @user.lessons.result_ids
      @learned_words = Meaning.remembered_words @user_result_ids
    end
  end

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
