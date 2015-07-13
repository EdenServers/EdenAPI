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
      create_env_variables(container)
      create_ports(container)

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

  def create_env_variables(container)
    unless params[:container][:environment_variables].nil?
      variables = JSON.parse(params[:container][:environment_variables])
      variables.each { |env|
        EnvironmentVariable.create(key: env['key'], value: env['value'], container: container)
      }
    end

  end
end
