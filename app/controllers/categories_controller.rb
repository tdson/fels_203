class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.search_name(params[:q]).order_by_name
      .paginate page: params[:page], per_page: Settings.category_per_page
  end
end
