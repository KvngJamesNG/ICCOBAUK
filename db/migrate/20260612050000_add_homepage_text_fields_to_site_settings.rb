class AddHomepageTextFieldsToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :home_convention_text, :string
    add_column :site_settings, :home_sponsor_text, :string
  end
end
