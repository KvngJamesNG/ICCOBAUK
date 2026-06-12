class Admin::SiteSettingsController < Admin::BaseController
  def show
    @site_setting = SiteSetting.current
  end

  def edit
    @site_setting = SiteSetting.current
  end

  def update
    @site_setting = SiteSetting.current

    if @site_setting.update(site_setting_params)
      redirect_to admin_site_setting_path, notice: "Site settings updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def site_setting_params
    params.require(:site_setting).permit(:theme_document_title, :theme_document)
  end
end
