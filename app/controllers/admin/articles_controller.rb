class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :set_authors, only: [ :new, :create, :edit, :update ]
  before_action :set_categories, only: [ :new, :create, :edit, :update ]

  def index
    @articles = Article.recent
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to admin_article_path(@article), notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to admin_article_path(@article), notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_articles_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :summary, :body, :author_name, :author_id, :article_category_id, :category, :published_on, :feature_image)
  end

  def set_authors
    @authors = Author.order(:name)
  end

  def set_categories
    @categories = ArticleCategory.order(:name)
  end
end
