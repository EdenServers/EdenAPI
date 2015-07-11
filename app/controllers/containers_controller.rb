class ContainersController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  api! "Return a list of all the containers installed on the server"
  def index
    render json: Container.all.to_json(:include => :ports)
  end

  api! "Displays a container"
  param :id, Integer, required: true
  def show
    show_object(Container, params[:id])
  end

  api! "Create a new container"
  param :container, Hash, required: true do
    param :image_id, Integer, required: true, desc: "Image id"
    param :name, String, desc: "Name of the container"
    param :description, String, "Description of the conainter"
    param :command, String, "Launch command of the container"
    param :ports, Hash, desc: 'Hash containing every ports. Sample hash : [{"host_port": 25565, "container_port": 25565, "port_type": "tcp"}]'
  end
  def create
    begin
      container = Container.new(container_params)
      container.image = Image.find(params[:container][:image_id])

      if container.save
        create_ports(container)
        render_200_object(container)
      else
        render_500_error(container)
      end
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  api! "Destroy the container"
  param :id, Integer, required: true, desc: "Container's id"
  def destroy
    delete_object(Container, params[:id])
  end

  api! "Update the container"
  param :id, Integer, required: true, desc: "Container's id"
  param :container, Hash, required: true do
    param :image_id, Integer, required: true, desc: "Image id"
    param :name, String, desc: "Name of the container"
    param :description, String, "Description of the conainter"
    param :command, String, "Launch command of the container"
    param :ports, Hash, desc: "Binding container ports and system ports"
  end
  def update
    update_object(Container, params[:id], container_params)
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end

  def create_ports(container)
    unless params[:container][:ports].nil?
      given_ports = JSON.parse(params[:container][:ports])
      given_ports.each { |p|
        Port.create(host_port: p['host_port'], container_port: p['container_port'], port_type: p['port_type'], container: container)
      }
    end
  end
end
