class Container < ActiveRecord::Base
  belongs_to :image

  after_create :create_docker_container
  before_destroy :delete_docker_container

  def start
    container = get_docker_object
    if !container.nil?
      unless container.json['State']['Running']
        container.start('PublishAllPorts' => 'true')
      end
    end
  end

  def stop
    container = get_docker_object
    if !container.nil?
      if container.json['State']['Running']
        container.stop
      end
    end
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
    container = Docker::Container.create('Image' => self.image.image_id)
    self.docker_container_id = container.id
    self.save
  end
end
