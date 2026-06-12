class Admin::InfoPagesController < Admin::BaseController
  before_action :set_info_page, only: [ :show, :edit, :update, :destroy ]

  def index
    @info_pages = InfoPage.order(updated_at: :desc)
  end

  def show
  end

  def new
    @info_page = InfoPage.new(published: true)
  end

  def create
    @info_page = InfoPage.new(info_page_params)

    if @info_page.save
      redirect_to admin_info_page_path(@info_page), notice: "Info page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @info_page.update(info_page_params)
      redirect_to admin_info_page_path(@info_page), notice: "Info page was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @info_page.destroy
    redirect_to admin_info_pages_path, notice: "Info page was successfully deleted."
  end

  private

  def set_info_page
    @info_page = InfoPage.find(params[:id])
  end

  def info_page_params
    params.require(:info_page).permit(:title, :slug, :body, :published)
  end
end
