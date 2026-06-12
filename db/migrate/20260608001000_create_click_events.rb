class CreateClickEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :click_events do |t|
      t.string :path
      t.string :target_url
      t.string :element_text
      t.string :ip_address
      t.string :device_type

      t.timestamps
    end

    add_index :click_events, :created_at
    add_index :click_events, :path
  end
end
