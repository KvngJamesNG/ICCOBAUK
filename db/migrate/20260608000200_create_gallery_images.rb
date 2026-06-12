class CreateGalleryImages < ActiveRecord::Migration[7.1]
  def change
    create_table :gallery_images do |t|
      t.string :title, null: false
      t.text :caption

      t.timestamps
    end
  end
end
