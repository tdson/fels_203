module CategoriesHelper
  def category_image category
    category.image? ? category.image.url : Settings.category_default_thumbnail
  end
end
