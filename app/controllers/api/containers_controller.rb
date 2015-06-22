class Api::ContainersController < ApplicationController
  def index
    render json: Container.all
  end

  def create
    container = Container.new(container_params)
    container.image = Image.find_by_image_id(params[:image_id])
    container.save
    render json: container
  end

  def delete
    container = Container.find(params[:id])
    if !container.nil?
      container.destroy!
    end
  end

  def update
    container = Container.find(params[:id])
    if container.update_attributes(container_params)
      render json: container
    else
      render json: {error: 'Couldn\'t update the container'}
    end
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end
end
