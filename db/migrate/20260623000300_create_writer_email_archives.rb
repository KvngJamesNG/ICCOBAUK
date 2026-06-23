class CreateWriterEmailArchives < ActiveRecord::Migration[7.1]
  def change
    create_table :writer_email_archives do |t|
      t.text :email_ciphertext, null: false
      t.string :email_digest, null: false
      t.string :last_username
      t.datetime :last_expires_at
      t.datetime :archived_at, null: false

      t.timestamps
    end

    add_index :writer_email_archives, :email_digest, unique: true
    add_index :writer_email_archives, :archived_at
  end
end
