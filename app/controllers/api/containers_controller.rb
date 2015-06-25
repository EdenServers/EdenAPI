class Api::ContainersController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Container.all
  end

  def create
    begin
      container = Container.new(container_params)
      container.image = Image.find(params[:container][:image_id])
      container.save ? render_200_container : render_500_error(container)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  def delete
    delete_object(Container, params[:id])
  end

  def update
    begin
      container = Container.find(params[:id])
      container.update_attributes(container_params) ? render_200_container : render_500_error(container)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end

  def render_200_container
    render status: 200, json: { container: container }
  end
end
