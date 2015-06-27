class ImagesController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Image.all
  end

  def create
      image = Image.new(image_params)
      image.save ? render_200_object(image) : render_500_error(image)
  end

  def delete
    delete_object(Image, params[:id])
  end

  def update
    update_object(Image, params[:id])
  end

  private
  def image_params
    params.require(:image).permit(:repo, :name)
  end
end
