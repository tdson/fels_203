class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_category, only: :destroy

  def index
    @categories = Category.includes(:words).search_name(params[:q]).newest
      .paginate page: params[:page], per_page: Settings.admin.category_per_page
    @category = Category.new
  end

  def create
    @category = Category.create category_params
    if @category.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fails"
    end
    redirect_to admin_categories_path
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.delete.success", resource: :Category
    else
      flash[:danger] = t "admin.delete.fails", resource: :category
    end
    redirect_to admin_categories_path
  end

  private
  def load_category
    @category = Category.find_by_id params[:id]
    unless @category
      flash[:danger] = t "admin.load_fails.category"
      redirect_to admin_categories_path
    end
  end

  def category_params
    params.require(:category).permit :name, :image
  end
end
