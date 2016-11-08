class UsersController < ApplicationController
  before_action :not_logged_in, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :show]
  before_action :load_user, only: [:edit, :update]
  before_action :verify_admin_or_correct_user, only: [:edit, :update]

  def index
    @users = User.search_name_or_email(params[:q])
      .order_by_name
      .paginate page: params[:page], per_page: Settings.user_per_page
  end

  def show
    @user = User.find_by_id params[:id]
    if @user
      @user_lessons = @user.lessons
      @user_result_ids = @user_lessons.result_ids
      @learned_words = Meaning.remembered_words @user_result_ids
      if current_user.active_relationships.find_by(followed: @user.id).nil?
        @active_relationship = current_user.active_relationships.build
      else
        @active_relationship = current_user.active_relationships
          .find_by(followed_id: @user.id)
      end
      load_data @user
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

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation, :current_password, :avatar, :is_admin
  end

  def load_user
    @user = User.find_by_id params[:id]
    unless @user
      flash[:danger] = t "users.load_fails"
      redirect_to :back
    end
  end

  def verify_admin_or_correct_user
    unless current_user.is_user?(@user) || admin?
      flash[:danger] = t "users.edit.access_denied"
      redirect_to @user
    end
  end
end
