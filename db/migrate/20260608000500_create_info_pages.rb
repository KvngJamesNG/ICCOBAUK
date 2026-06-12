class CreateInfoPages < ActiveRecord::Migration[7.1]
  def change
    create_table :info_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :info_pages, :slug, unique: true
  end
end
