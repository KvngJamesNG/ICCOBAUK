class Admin::DashboardController < Admin::BaseController
  def index
    @articles_count = Article.count
    @authors_count = Author.count
    @categories_count = ArticleCategory.count
    @verified_users_count = VerifiedUser.count
    @gallery_images_count = GalleryImage.count
    @slider_images_count = SliderImage.count
    @info_pages_count = InfoPage.count

    window_start = 30.days.ago
    recent_visits = SiteVisit.where("created_at >= ?", window_start)
    recent_clicks = ClickEvent.where("created_at >= ?", window_start)

    @visits_count = recent_visits.count
    @clicks_count = recent_clicks.count
    @device_breakdown = recent_visits.group(:device_type).count
    @top_paths = recent_visits.group(:path).order(Arel.sql("count_all DESC")).limit(5).count
    @top_referrers = recent_visits.where.not(referrer: [ nil, "" ]).group(:referrer).order(Arel.sql("count_all DESC")).limit(5).count
    @latest_verified_users = VerifiedUser.order(updated_at: :desc).limit(8)
  end
end
