class InfoPage < ApplicationRecord
  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: true

  before_validation :normalize_slug

  scope :published, -> { where(published: true) }

  private

  def normalize_slug
    self.slug = slug.to_s.parameterize if slug.present?
  end
end
