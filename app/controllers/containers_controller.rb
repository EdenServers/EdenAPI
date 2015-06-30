class ContainersController < ApplicationController
  include GenericMethodsConcern
  include HttpResponseConcern

  api :GET, '/containers', "Return a list of all the containers installed on the server"
  example '[
    {
        "id": 1,
        "name": "test",
        "description": null,
        "command": null,
        "created_at": "2015-06-27T15:39:33.058Z",
        "updated_at": "2015-06-27T19:35:47.347Z",
        "docker_container_id": "05533d9bc778b3bc3eb732297f2216298aecb91a0e5f328d703b15ddddf9b86a",
        "image_id": 3,
        "ports": []
    },
    ...
]'
  def index
    render json: Container.all.to_json(:include => :ports)
  end

  api :POST, '/containers', "Create a new container"
  param :container, Hash, required: true do
    param :image_id, Integer, required: true, desc: "Image id"
    param :name, String, desc: "Name of the container"
    param :description, String, "Description of the conainter"
    param :command, String, "Launch command of the container"
    param :ports, Hash, desc: "Binding container ports and system ports" do
      param :host_port, Integer, desc: "System port"
      param :container_port, Integer, desc: "Container port"
      param :port_type, String, desc: "Port type (tcp, udp, ...)"
    end
  end
  example '
    {
        "id": 1,
        "name": "test",
        "description": null,
        "command": null,
        "created_at": "2015-06-27T15:39:33.058Z",
        "updated_at": "2015-06-27T19:35:47.347Z",
        "docker_container_id": "05533d9bc778b3bc3eb732297f2216298aecb91a0e5f328d703b15ddddf9b86a",
        "image_id": 3,
        "ports": []
    }'
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

  api :DELETE, '/containers/:id', "Destroy the container"
  param :id, Integer, required: true, desc: "Container's id"
  def destroy
    delete_object(Container, params[:id])
  end

  api :PUT, '/containers/:id', "Update the container"
  param :id, Integer, required: true, desc: "Container's id"
  param :container, Hash, required: true do
    param :image_id, Integer, required: true, desc: "Image id"
    param :name, String, desc: "Name of the container"
    param :description, String, "Description of the conainter"
    param :command, String, "Launch command of the container"
    param :ports, Hash, desc: "Binding container ports and system ports" do
      param :host_port, Integer, desc: "System port"
      param :container_port, Integer, desc: "Container port"
      param :port_type, String, desc: "Port type (tcp, udp, ...)"
    end
  end
  def update
    update_object(Container, params[:id], container_params)
  end

  private
  def container_params
    params.require(:container).permit(:name, :description, :image_id, :command)
  end
end
