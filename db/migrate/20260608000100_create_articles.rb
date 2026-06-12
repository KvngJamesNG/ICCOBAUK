class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :summary, null: false
      t.text :body, null: false
      t.string :author_name, null: false
      t.string :category
      t.date :published_on, null: false

      t.timestamps
    end
  end
end
