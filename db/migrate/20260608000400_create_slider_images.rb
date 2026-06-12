class CreateSliderImages < ActiveRecord::Migration[7.1]
  def change
    create_table :slider_images do |t|
      t.string :title, null: false
      t.text :caption
      t.string :link_url
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
