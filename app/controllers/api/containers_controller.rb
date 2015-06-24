class Api::ContainersController < ApplicationController
  def index
    render json: Container.all
  end

  def create
    container = Container.new(container_params)

    begin
      container.image = Image.find(params[:container][:image_id])
      container.save ? render(status: 200, json:{ container: container }) : render(status: 500, json: { error: container.errors })
    rescue ActiveRecord::RecordNotFound => e
      render status: 500, json: { error:  e }
    end
  end

  def delete
    container = Container.find(params[:id])

    begin
      container.destroy
      container.destroyed? ? render(:nothing, status: 200) : render(status: 200, json: { error: container.errors })
    rescue ActiveRecord::RecordNotFound => e
      render status: 500, json: { error:  e }
    end
  end

  def update
    container = Container.find(params[:id])

    begin
      container.update_attributes(container_params) ? render(status: 200, json: { container: container }) : render(status: 500, json: { error: container.errors })
    rescue ActiveRecord::RecordNotFound => e
      render status: 500, json: { error:  e }
    end
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end
end
