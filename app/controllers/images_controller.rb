class ImagesController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Image.all
  end

  def show
    show_object(Image, params[:id])
  end

  def create
      image = Image.new(image_params)
      image.save ? render_200_object(image) : render_500_object_error(image)
  end

  def destroy
    delete_object(Image, params[:id])
  end

  def update
    update_object(Image, params[:id], image_params)
  end

  private
  def image_params
    params.require(:image).permit(:repo, :name)
  end
end
