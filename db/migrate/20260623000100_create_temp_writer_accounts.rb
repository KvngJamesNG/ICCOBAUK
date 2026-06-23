class CreateTempWriterAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :temp_writer_accounts do |t|
      t.string :username, null: false
      t.string :password_salt, null: false
      t.string :password_digest, null: false
      t.datetime :expires_at, null: false
      t.string :created_by

      t.timestamps
    end

    add_index :temp_writer_accounts, :username, unique: true
    add_index :temp_writer_accounts, :expires_at
  end
end
