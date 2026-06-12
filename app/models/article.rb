class Article < ApplicationRecord
  belongs_to :author, optional: true
  belongs_to :article_category, optional: true
  has_one_attached :feature_image
  has_many :article_comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy

  validates :title, :summary, :body, :author_name, :published_on, presence: true

  scope :recent, -> { order(published_on: :desc, created_at: :desc) }

  before_validation :sync_author_name

  def category_label
    article_category&.name.presence || category
  end

  def reaction_for(email)
    article_likes.find_by(email: email)&.reaction
  end

  private

  def sync_author_name
    self.author_name = author.name if author.present?
  end
end
