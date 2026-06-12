class ArticlesController < ApplicationController
  def index
    @articles = Article.recent
  end

  def show
    @article = Article.find(params[:id])
    @verified_email = session[verified_email_session_key]
    @verified_name = session[verified_name_session_key]
    @engagement_unlocked = @verified_email.present? && @verified_name.present?
    @comments = @article.article_comments.recent
    @likes_count = @article.article_likes.count
    @reaction_counts = @article.article_likes.group(:reaction).count
  end

  private

  def verified_email_session_key
    "verified_commenter_email_article_#{@article.id}".to_sym
  end

  def verified_name_session_key
    "verified_commenter_name_article_#{@article.id}".to_sym
  end
end
