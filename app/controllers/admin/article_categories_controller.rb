class Admin::ArticleCategoriesController < Admin::BaseController
  before_action :set_article_category, only: %i[edit update destroy]

  def index
    @article_categories = ArticleCategory.order(:name)
    @article_category = ArticleCategory.new
  end

  def create
    @article_category = ArticleCategory.new(article_category_params)
    if @article_category.save
      redirect_to admin_article_categories_path, notice: "Category created successfully."
    else
      @article_categories = ArticleCategory.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article_category.update(article_category_params)
      redirect_to admin_article_categories_path, notice: "Category updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article_category.destroy
    redirect_to admin_article_categories_path, notice: "Category deleted."
  end

  private

  def set_article_category
    @article_category = ArticleCategory.find(params[:id])
  end

  def article_category_params
    params.require(:article_category).permit(:name)
  end
end
