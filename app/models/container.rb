# == Schema Information
#
# Table name: containers
#
#  id                  :integer          not null, primary key
#  name                :string
#  description         :text
#  command             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  docker_container_id :string
#  image_id            :integer
#

class Container < ActiveRecord::Base
  belongs_to :image
  has_many :ports, dependent: :destroy
  has_many :environment_variables, dependent: :destroy

  after_create :create_ports, :create_env_variables, :create_docker_container

  attr_accessor :environment_variables_list, :ports_list

  validates_presence_of :image, :name

  before_destroy :delete_docker_container

  def start
    container = get_docker_object
    unless container.nil? || running
      container.start("PortBindings"=> get_port_bindings)
      self.running = true
      Container.delay(run_at: 15.seconds.from_now).check_running_job(self.id)
      self.save
    end
  end

  def stop
    container = get_docker_object
    if !container.nil? && running
      container.stop
      self.running = false
      self.save
    end
  end

  def self.check_running_job(container_id)
    container = Container.find(container_id)
    if !container.get_docker_object.json['State']['Running']
      container.running = false
      container.save
    else
      Container.delay(run_at: 15.seconds.from_now).check_running_job(container_id)
    end
  end

  def get_docker_object
    begin
      Docker::Container.get(self.docker_container_id)
    rescue Docker::Error::NotFoundError
      nil
    end
  end

  #Gets the list of ports bindings in order to start the container
  def get_port_bindings
    port_bindings = {}
    self.ports.each{ |p| port_bindings["#{p.container_port}/#{p.port_type}"] = [{ "HostPort"=> p.host_port.to_s }] }
    port_bindings
  end

  #Gets the list of exposed ports in order to create the container
  def get_exposed_ports
    port_bindings = {}
    self.ports.each{ |p| port_bindings["#{p.container_port}/#{p.port_type}"] = {} }
    port_bindings
  end

  #Gets the list of environment variable in order to create the container
  def get_environment_variables
    environment_variables = []
    self.environment_variables.each { |env| environment_variables << "#{env.key}=#{env.value}" }
    environment_variables
  end

  #Used to delete the container from docker
  def delete_docker_container
    self.get_docker_object.delete(:force => true) unless self.get_docker_object.nil?
  end

  #Used to create the ports assigned to the container
  def create_ports
    unless self.ports_list.nil?
      given_ports = JSON.parse(self.ports_list)
      given_ports.each { |p|
        Port.create(host_port: p['host_port'], container_port: p['container_port'], port_type: p['port_type'], container: self)
      }
    end
  end

  #Used to create the environment variables assigned to the container
  def create_env_variables
    unless self.environment_variables_list.nil?
      variables = JSON.parse(self.environment_variables_list)
      variables.each { |env|
        EnvironmentVariable.create(key: env['key'], value: env['value'], container: self)
      }
    end
  end

  #Used to create the container in docker
  def create_docker_container
    container = Docker::Container.create('Image' => self.image.docker_image_id, 'Env' => get_environment_variables, 'ExposedPorts' => get_exposed_ports)
    self.docker_container_id = container.id
    self.save
  end
end