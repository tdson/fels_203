class WordsController < ApplicationController
  before_action :logged_in_user

  def index
    params[:condition] ||= Settings.word_filters[:get_all]
    @categories = Category.order_by_name
    @words_full = Word.includes(:meanings, :category)
      .search_word_or_category(params[:q])
      .of_category(params[:category_id])
      .only_correct_meaning
      .order_by_alphabetical_content
    if params[:condition].present? &&
      params[:condition] != Settings.word_filters[:get_all]
      @words_full = @words_full.send(params[:condition], current_user.id)
    end
    @words = @words_full.paginate page: params[:page],
      per_page: Settings.word_per_page

    export_file_name = "#{Settings.exp_file_name}_#{params[:condition]}.csv"
    respond_to do |format|
      format.html
      format.xls
      format.csv {send_data @words_full.to_csv, filename: export_file_name}
    end
  end
end
