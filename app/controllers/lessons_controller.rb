class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_category, only: [:create, :edit]
  before_action :load_lesson, only: [:update, :edit, :show]
  before_action :check_available_words, only: :create
  before_action :first_update, only: [:edit, :update]
  before_action :correct_user, only: :index

  def index
    @lessons = @user.lessons.includes(:category, results: :meaning)
      .newest
      .paginate page: params[:page], per_page: Settings.lesson_per_page
  end

  def create
    @lesson = @category.lessons.build user: current_user
    if @lesson.save
      redirect_to edit_category_lesson_path @category, @lesson
    else
      flash[:danger] = t ".fails"
      redirect_to categories_path
    end
  end

  def edit
    @results = @lesson.results.includes word: :meanings
  end

  def update
    params = lesson_params
    params[:is_finished] = true;
    if @lesson.update_attributes params
      redirect_to category_lesson_path @lesson.category, @lesson
    else
      flash[:danger] = ".fails"
      redirect_to categories_path
    end
  end

  def show
    @results = @lesson.results
    @scores = @results.correct_meanings.count
    @results = @results.includes word: :meanings
  end

  private
  def lesson_params
    params.require(:lesson)
      .permit :is_finished, results_attributes: [:id, :meaning_id]
  end

  def load_category
    @category = Category.find_by_id params[:category_id]
    unless @category
      flash[:danger] = t "lessons.load_fails"
      redirect_to categories_path
    end
  end

  def load_lesson
    @lesson = Lesson.find_by_id params[:id]
    unless @lesson
      flash[:danger] = t "lessons.load_fails"
      redirect_to categories_path
    end
  end

  def first_update
    redirect_to categories_path if @lesson.first_update?
  end

  def check_available_words
    if @category.words.count < Settings.word_per_lesson
      flash[:warning] = t ".not_enough_word"
      redirect_to categories_path
    end
  end

  def correct_user
    @user = User.find_by_id params[:user_id]
    unless @user
      flash[:danger] = t "lessons.index.user_not_found"
      redirect_to categories_path and return
    end
    unless current_user.is_user? @user
      flash[:danger] = t "lessons.index.access_denied"
      redirect_to user_lessons_path current_user
    end
  end
end
