class ImagesController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  api :GET, '/images', "Return a list of all the images installed"
  example '[
    {
        "id": 3,
        "docker_image_id": "193bcb80729f",
        "name": "Minecraft",
        "description": "Minecraft Server",
        "created_at": "2015-06-27T14:27:19.346Z",
        "updated_at": "2015-06-27T14:27:25.045Z",
        "repo": "dernise/minecraft",
        "ready": true,
        "ports": null
    },
    ...
]'
  def index
    render json: Image.all
  end

  api :POST, '/images', "Create a new image"
  param :image, Hash, required: true do
    param :name, String, desc: "Image's name"
    param :description, String, desc: "Image's description"
    param :repo, String, required: true, desc: "Image's repository"
  end
  example '
  {
    "id": 3,
    "docker_image_id": "193bcb80729f",
    "name": "Minecraft",
    "description": "Minecraft Server",
    "created_at": "2015-06-27T14:27:19.346Z",
    "updated_at": "2015-06-27T14:27:25.045Z",
    "repo": "dernise/minecraft",
    "ready": true,
    "ports": null
  }'
  def create
      image = Image.new(image_params)
      image.save ? render_200_object(image) : render_500_error(image)
  end

  api :DELETE, '/images/:id', "Destroy the image"
  param :id, Integer, required: true, desc: "Image's id"
  def destroy
    delete_object(Image, params[:id])
  end

  api :PUT, '/images/:id', "Update the image"
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
