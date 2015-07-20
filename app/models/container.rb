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
  has_many :ports
  has_many :environment_variables

  validates_presence_of :image, :name

  after_create :create_docker_container
  before_destroy :delete_docker_container

  def start
    container = get_docker_object
    unless container.nil? || container.json['State']['Running']
      container.start('PublishAllPorts' => 'true',
                      "PortBindings"=> get_port_bindings)
    end
  end

  def stop
    container = get_docker_object
    container.stop if !container.nil? && container.json['State']['Running']
  end

  def get_docker_object
    begin
      Docker::Container.get(self.docker_container_id)
    rescue Docker::Error::NotFoundError
      nil
    end
  end

  def get_port_bindings
    port_bindings = {}
    self.ports.each{ |p| port_bindings["#{p.container_port}/#{p.port_type}"] =  [{ "HostPort"=> p.host_port.to_s }] }
    port_bindings
  end

  def get_environment_variables
    environment_variables = []
    self.environment_variables.each { |env| environment_variables << "#{env.key}=#{env.value}" }
    environment_variables
  end

  def delete_docker_container
    self.get_docker_object.delete(:force => true) unless self.get_docker_object.nil?
  end

  def create_docker_container
    container = Docker::Container.create('Image' => self.image.docker_image_id, 'Env' => get_environment_variables)
    self.docker_container_id = container.id
    self.save
  end
end
