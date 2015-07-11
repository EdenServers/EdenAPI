class ImagesController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  api! "Return a list of all the images installed"
  def index
    render json: Image.all
  end

  api! "Displays an image"
  param :id, Integer, required: true
  def show
    show_object(Image, params[:id])
  end

  api!
  param :image, Hash, required: true do
    param :name, String, desc: "Image's name"
    param :description, String, desc: "Image's description"
    param :repo, String, required: true, desc: "Image's repository"
  end
  def create
      image = Image.new(image_params)
      image.save ? render_200_object(image) : render_500_error(image)
  end

  api! "Destroy the image"
  param :id, Integer, required: true, desc: "Image's id"
  def destroy
    delete_object(Image, params[:id])
  end

  api! "Update the image"
  param :id, Integer, required: true, desc: "Image's id"
  param :image, Hash, required: true do
    param :name, String, desc: "Image's name"
    param :description, String, desc: "Image's description"
    param :repo, String, required: true, desc: "Image's repository"
  end
  def update
    update_object(Image, params[:id], image_params)
  end

  private
  def image_params
    params.require(:image).permit(:repo, :name)
  end
end
