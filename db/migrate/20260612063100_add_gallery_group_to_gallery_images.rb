class AddGalleryGroupToGalleryImages < ActiveRecord::Migration[7.1]
  def change
    add_reference :gallery_images, :gallery_group, foreign_key: true
  end
end
