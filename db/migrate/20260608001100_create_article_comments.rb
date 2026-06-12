class CreateArticleComments < ActiveRecord::Migration[7.1]
  def change
    create_table :article_comments do |t|
      t.references :article, null: false, foreign_key: true
      t.string :email, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
