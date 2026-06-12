class Admin::SliderImagesController < Admin::BaseController
  before_action :set_slider_image, only: [ :show, :edit, :update, :destroy ]

  def index
    @slider_images = SliderImage.ordered
  end

  def show
  end

  def new
    @slider_image = SliderImage.new(active: true)
  end

  def create
    @slider_image = SliderImage.new(slider_image_params)

    if @slider_image.save
      redirect_to admin_slider_image_path(@slider_image), notice: "Slider image was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @slider_image.update(slider_image_params)
      redirect_to admin_slider_image_path(@slider_image), notice: "Slider image was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @slider_image.destroy
    redirect_to admin_slider_images_path, notice: "Slider image was successfully deleted."
  end

  private

  def set_slider_image
    @slider_image = SliderImage.find(params[:id])
  end

  def slider_image_params
    params.require(:slider_image).permit(:title, :caption, :link_url, :position, :active, :image)
  end
end
