class AddAdminCredentialsToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :admin_username, :string
    add_column :site_settings, :admin_password, :string
  end
end
