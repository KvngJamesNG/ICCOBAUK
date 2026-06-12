class Admin::AuthorsController < Admin::BaseController
  before_action :set_author, only: [ :show, :edit, :update, :destroy ]

  def index
    @authors = Author.order(:name)
  end

  def show
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to admin_author_path(@author), notice: "Author created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @author.update(author_params)
      redirect_to admin_author_path(@author), notice: "Author updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    author_name = @author.name
    @author.destroy
    redirect_to admin_authors_path, notice: "Author #{author_name} deleted."
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :email, :role)
  end
end
