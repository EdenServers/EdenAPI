class PortsController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  def index
    render json: Port.all
  end

  def create
    begin
      port = Port.new(port_params)
      port.container = Container.find(params[:port][:container_id])
      port.save ? render_200_object(port) : render_500_error(port)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  api! "Displays a port"
  param :id, Integer, required: true
  def show
    show_object(Port, params[:id])
  end

  def destroy
    delete_object(Port, params[:id])
  end

  def update
    update_object(Port, params[:id], port_params)
  end

  private
  def port_params
    params.require(:port).permit(:host_port, :container_port, :port_type, :container_id)
  end
end
