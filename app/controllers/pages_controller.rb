class PagesController < ApplicationController
  def home
    @slider_images = SliderImage.active.ordered
    @featured_articles = Article.recent.limit(3)
    @latest_article = @featured_articles.first
    @recent_gallery_images = GalleryImage.recent.limit(8)
    @site_setting = SiteSetting.current
  end

  def contact_us
  end

  def blog_post
  end

  def blog_post2
  end

  def blog_post3
  end

  def blog_post4
  end

  def blog_home
    @articles = Article.recent
  end

  def about_us
  end

  def faq
  end

  def portfolio_item
  end

  def portfolio_item2
  end

  def portfolio_item3
  end

  def portfolio_overview
    @gallery_groups = GalleryGroup.includes(gallery_images: [ image_attachment: :blob ]).ordered
    @ungrouped_gallery_images = GalleryImage.includes(image_attachment: :blob).where(gallery_group_id: nil).recent
  end

  def events
  end
end
