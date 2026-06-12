class CreateArticleCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :article_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :article_categories, :name, unique: true
    add_reference :articles, :article_category, foreign_key: true
  end
end
