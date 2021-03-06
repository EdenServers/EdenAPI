class PortsController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Port.all.to_json(:include => [:container])
  end

  def create
    begin
      port = Port.new(port_params)
      port.container = Container.find(params[:port][:container_id])
      port.save ? render_200_object(port) : render_500_object_error(port)
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  def show
    show_object(Port, params[:id], inclusions: [:container])
  end

  def destroy
    delete_object(Port, params[:id])
  end

  def update
    update_object(Port, params[:id], port_params)
  end

  def check_port
    port = Port.where('host_port = ?', params[:port_id])
    if port.empty?
      render_200_object({available: true})
    else
      render_200_object({available: false, port: port.first})
    end
  end

  private
  def port_params
    params.require(:port).permit(:host_port, :container_port, :port_type, :container_id)
  end
end
