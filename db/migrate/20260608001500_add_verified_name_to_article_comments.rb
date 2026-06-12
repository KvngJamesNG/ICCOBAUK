class AddVerifiedNameToArticleComments < ActiveRecord::Migration[7.1]
  def change
    add_column :article_comments, :verified_name, :string
  end
end
