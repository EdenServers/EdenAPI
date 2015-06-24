class Api::ContainersController < ApplicationController
  def index
    render json: Container.all
  end

  def create
    container = Container.new(container_params)
    container.image = Image.find(params[:container][:image_id])
    if container.save
      render status: 200, json:{container: container}
    else
      render status: 500, json: {message: 'Couldn\'t save the container', error: container.errors}
    end
  end

  def delete
    container = Container.find(params[:id])
    if !container.nil?
      container.destroy
      if container.destroyed?
        render :nothing, status: 200
      else
        render status: 200, json: {message: 'Couldn\'t delete the container', error: container.errors}
      end
    end
  end

  def update
    container = Container.find(params[:id])
    if container.update_attributes(container_params)
      render status: 200, json: {container: container}
    else
      render status: 500, json: {message: 'Couldn\'t update the container', error: container.errors}
    end
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end
end
