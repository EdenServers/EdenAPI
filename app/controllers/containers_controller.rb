class ContainersController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Container.all.to_json(:include => [:ports, :environment_variables])
  end

  def show
    show_object(Container, params[:id])
  end

  def create
    begin
      container = Container.new(container_params)
      image = Image.find(params[:container][:image_id])

      return render_500_error 'image_not_ready' unless image.ready?

      container.image = image

      if container.save
        render_200_object(container)
      else
        render_500_object_error(container)
      end
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  def destroy
    delete_object(Container, params[:id])
  end

  def update
    update_object(Container, params[:id], container_params)
  end

  def start
    begin
      container = Container.find(params[:container_id])
      container.start
      render_200_object container
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  def stop
    begin
      container = Container.find(params[:container_id])
      container.stop
      render_200_object container
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command, :environment_variables_list, :ports_list)
  end
end
