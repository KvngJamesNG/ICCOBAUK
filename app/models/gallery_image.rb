class GalleryImage < ApplicationRecord
  has_one_attached :image
  belongs_to :gallery_group, optional: true

  validates :title, presence: true
  validates :image, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
