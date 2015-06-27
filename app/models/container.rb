# == Schema Information
#
# Table name: containers
#
#  id                  :INTEGER          not null, primary key
#  name                :varchar
#  description         :text
#  command             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  docker_container_id :varchar
#  image_id            :integer
#

class Container < ActiveRecord::Base
  belongs_to :image

  after_create :create_docker_container
  before_destroy :delete_docker_container

  def start
    container = get_docker_object
    container.start('PublishAllPorts' => 'true') unless container.nil? || container.json['State']['Running']
  end

  def stop
    container = get_docker_object
    container.stop unless container.nil? || container.json['State']['Running']
  end

  def get_docker_object
    begin
      Docker::Container.get(self.docker_container_id)
    rescue Docker::Error::NotFoundError
      nil
    end
  end

  def delete_docker_container
    self.get_docker_object.delete(:force => true)
  end

  def create_docker_container
    container = Docker::Container.create('Image' => self.image.docker_image_id)
    self.docker_container_id = container.id
    self.save
  end
end
