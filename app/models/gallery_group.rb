class GalleryGroup < ApplicationRecord
  has_many :gallery_images, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(name: :asc) }
end
