class CreateGalleryGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :gallery_groups do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :gallery_groups, :name, unique: true
  end
end
