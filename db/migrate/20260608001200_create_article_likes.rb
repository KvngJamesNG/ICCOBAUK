class CreateArticleLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :article_likes do |t|
      t.references :article, null: false, foreign_key: true
      t.string :email, null: false

      t.timestamps
    end

    add_index :article_likes, [ :article_id, :email ], unique: true
  end
end
