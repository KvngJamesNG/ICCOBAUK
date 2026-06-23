class AddEmailToTempWriterAccounts < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:temp_writer_accounts, :email_ciphertext)
      add_column :temp_writer_accounts, :email_ciphertext, :text
    end

    unless column_exists?(:temp_writer_accounts, :email_digest)
      add_column :temp_writer_accounts, :email_digest, :string
    end

    unless index_exists?(:temp_writer_accounts, :email_digest, unique: true)
      add_index :temp_writer_accounts, :email_digest, unique: true
    end
  end
end
