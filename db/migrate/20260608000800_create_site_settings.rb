class CreateSiteSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :site_settings do |t|
      t.string :theme_document_title

      t.timestamps
    end
  end
end
