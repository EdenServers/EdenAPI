class ContainersController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Container.all.to_json(:include => :ports)
  end

  def create
    begin
      container = Container.new(container_params)
      container.image = Image.find(params[:container][:image_id])

      if container.save
        unless params[:container][:ports].nil?
          given_ports = JSON.parse(params[:container][:ports])
          given_ports.each { |p|
            Port.create(host_port: p['host_port'], container_port: p['container_port'], port_type: p['port_type'], container: container)
          }
        end
        render_200_object(container)
      else
        render_500_error(container)
      end
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  def destroy
    delete_object(Container, params[:id])
  end

  def update
    update_object(Container, params[:id], container_params)
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end
end
