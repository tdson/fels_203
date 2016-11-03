class Admin::WordsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_word, only: :destroy

  def index
    @categories = Category.order_by_name.select :id, :name
    @words = Word.search_content(params[:q])
      .of_category(params[:category_id])
      .includes(:category)
      .order_by_alphabetical_content
      .paginate page: params[:page], per_page: Settings.admin.word_per_page
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
end
