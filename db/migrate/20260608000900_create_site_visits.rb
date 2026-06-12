class CreateSiteVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :site_visits do |t|
      t.string :path, null: false
      t.string :referrer
      t.string :ip_address
      t.string :user_agent
      t.string :device_type

      t.timestamps
    end

    add_index :site_visits, :created_at
    add_index :site_visits, :path
    add_index :site_visits, :device_type
  end
end
