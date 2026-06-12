class ArticleInteractionsController < ApplicationController
  before_action :set_article

  def verify_email
    name = params[:name].to_s.strip
    email = params[:email].to_s.strip.downcase

    if name.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      session[verified_email_session_key] = email
      session[verified_name_session_key] = name

      verified_user = VerifiedUser.find_or_initialize_by(email: email)
      verified_user.name = name
      verified_user.save!

      redirect_to article_path(@article), notice: "Verification complete. You can now react and comment."
    else
      redirect_to article_path(@article), alert: "Please enter your name and a valid email address."
    end
  end

  def create_like
    email = session[verified_email_session_key]
    name = session[verified_name_session_key]
    return redirect_to(article_path(@article), alert: "Verify your email first.") if email.blank?

    like = @article.article_likes.find_or_initialize_by(email: email)
    like.reaction = params[:reaction].presence || "up"
    if like.persisted? || like.save
      redirect_to article_path(@article), notice: "Thanks for your reaction, #{name.presence || 'friend'}."
    else
      redirect_to article_path(@article), alert: "Unable to save your like right now."
    end
  end

  def create_comment
    email = session[verified_email_session_key]
    name = session[verified_name_session_key]
    return redirect_to(article_path(@article), alert: "Verify your email first.") if email.blank?

    comment = @article.article_comments.new(email: email, verified_name: name, content: params[:content])
    if comment.save
      redirect_to article_path(@article), notice: "Comment posted successfully."
    else
      redirect_to article_path(@article), alert: comment.errors.full_messages.to_sentence
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def verified_email_session_key
    "verified_commenter_email_article_#{@article.id}".to_sym
  end

  def verified_name_session_key
    "verified_commenter_name_article_#{@article.id}".to_sym
  end
end
