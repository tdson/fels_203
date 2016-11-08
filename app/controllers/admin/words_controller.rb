class Admin::WordsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_category, only: :create
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_word, only: [:edit, :update, :destroy]

  def index
    @words = Word.search_content(params[:q])
      .of_category(params[:category_id])
      .includes(:category)
      .order_by_alphabetical_content
      .paginate page: params[:page], per_page: Settings.admin.word_per_page
    @word = Word.new
  end

  def new
    @word = Word.new
  end

  def create
    @word = @category.words.create word_params
    if @word.save
      flash[:success] = t ".success"
      redirect_to admin_words_path
    else
      render :new
    end
  end

  def edit
    @cate_id = @word.category_id if @word
    render :edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t ".success"
      redirect_to admin_words_path
    else
      render :edit
    end
  end

  def destroy
    if @word.destroy
      flash[:success] = t "admin.delete.success",
        resource: t("admin.words.resource").capitalize
    else
      flash[:danger] = t "admin.delete.fails",
        resource: t("admin.words.resource")
    end
    redirect_to admin_words_path
  end

  private
  def load_word
    @word = Word.find_by_id params[:id]
    unless @word
      flash[:danger] = t "admin.load_fails.word"
      redirect_to admin_words_path
    end
  end

  def load_category
    @category = Category.find_by_id params[:word][:category_id]
    unless @category
      flash[:danger] = t "admin.load_fails.category"
      redirect_to new_admin_word_path
    end
  end

  def load_categories
    @categories = Category.order_by_name
  end

  def word_params
    params.require(:word).permit :category_id, :content,
      meanings_attributes: [:id, :content, :is_correct, :_destroy]
  end
end
