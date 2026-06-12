class SliderImage < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true
  validates :position, numericality: { only_integer: true }
  validates :image, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }

  # Default slider image size: 1000x600px at 90% quality for fast load times
  # while preserving visual quality
  def image_variant
    image.variant(resize_to_fit: [1000, 600], quality: 90).processed
  end
end
