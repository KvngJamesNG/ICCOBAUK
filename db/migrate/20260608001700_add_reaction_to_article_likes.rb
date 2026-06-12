class AddReactionToArticleLikes < ActiveRecord::Migration[7.1]
  def change
    add_column :article_likes, :reaction, :string, null: false, default: "up"
  end
end
