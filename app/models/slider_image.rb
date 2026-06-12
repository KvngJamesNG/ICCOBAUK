class SliderImage < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true
  validates :position, numericality: { only_integer: true }
  validates :image, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }
end
