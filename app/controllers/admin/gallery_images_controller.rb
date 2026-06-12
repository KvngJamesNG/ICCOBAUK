class Admin::GalleryImagesController < Admin::BaseController
  before_action :set_gallery_image, only: [ :show, :edit, :update, :destroy ]
  before_action :set_gallery_groups, only: [ :new, :create, :edit, :update ]

  def index
    @gallery_images = GalleryImage.includes(:gallery_group).recent
  end

  def show
  end

  def new
    @gallery_image = GalleryImage.new
    @gallery_image.gallery_group_id = params[:gallery_group_id] if params[:gallery_group_id].present?
  end

  def create
    uploaded_images = Array(params.dig(:gallery_image, :images)).reject(&:blank?)
    single_image = params.dig(:gallery_image, :image)

    if uploaded_images.any?
      create_multiple_images(uploaded_images)
      return
    end

    @gallery_image = GalleryImage.new(gallery_image_params.except(:images))
    @gallery_image.image.attach(single_image) if single_image.present?

    if @gallery_image.save
      redirect_to admin_gallery_image_path(@gallery_image), notice: "Gallery image was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gallery_image.update(gallery_image_params)
      redirect_to admin_gallery_image_path(@gallery_image), notice: "Gallery image was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gallery_image.destroy
    redirect_to admin_gallery_images_path, notice: "Gallery image was successfully deleted."
  end

  private

  def set_gallery_image
    @gallery_image = GalleryImage.find(params[:id])
  end

  def gallery_image_params
    params.require(:gallery_image).permit(:title, :caption, :image, :gallery_group_id, images: [])
  end

  def set_gallery_groups
    @gallery_groups = GalleryGroup.ordered
  end

  def create_multiple_images(uploaded_images)
    base_attributes = gallery_image_params.except(:image, :images)
    base_title = base_attributes.delete(:title).to_s.strip
    created_count = 0
    failing_image = nil

    GalleryImage.transaction do
      uploaded_images.each_with_index do |uploaded_image, index|
        generated_title = if base_title.present?
          uploaded_images.size == 1 ? base_title : "#{base_title} #{index + 1}"
        else
          File.basename(uploaded_image.original_filename.to_s, ".*").tr("_-", " ").strip.presence || "Gallery Image #{index + 1}"
        end

        gallery_image = GalleryImage.new(base_attributes.merge(title: generated_title))
        gallery_image.image.attach(uploaded_image)

        unless gallery_image.save
          failing_image = gallery_image
          raise ActiveRecord::Rollback
        end

        created_count += 1
      end
    end

    if failing_image
      @gallery_image = failing_image
      render :new, status: :unprocessable_entity
    else
      redirect_to admin_gallery_images_path, notice: "#{created_count} gallery images were successfully created."
    end
  end
end
