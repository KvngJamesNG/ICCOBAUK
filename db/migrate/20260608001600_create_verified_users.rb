class CreateVerifiedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :verified_users do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :verified_users, :email, unique: true
  end
end
