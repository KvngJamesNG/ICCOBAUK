class Admin::GalleryGroupsController < Admin::BaseController
  before_action :set_gallery_group, only: [ :show, :edit, :update, :destroy ]

  def index
    @gallery_groups = GalleryGroup.includes(:gallery_images).ordered
  end

  def show
    @gallery_images = @gallery_group.gallery_images.includes(image_attachment: :blob).recent
  end

  def new
    @gallery_group = GalleryGroup.new
  end

  def create
    @gallery_group = GalleryGroup.new(gallery_group_params)

    if @gallery_group.save
      redirect_to admin_gallery_groups_path, notice: "Gallery group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gallery_group.update(gallery_group_params)
      redirect_to admin_gallery_groups_path, notice: "Gallery group was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gallery_group.destroy
    redirect_to admin_gallery_groups_path, notice: "Gallery group was successfully deleted."
  end

  private

  def set_gallery_group
    @gallery_group = GalleryGroup.find(params[:id])
  end

  def gallery_group_params
    params.require(:gallery_group).permit(:name)
  end
end
