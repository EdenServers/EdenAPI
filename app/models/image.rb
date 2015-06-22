class Image < ActiveRecord::Base
  after_create :start_docker_creation_job

  validates :repo, :presence => true
  validates :name, :presence => true

  has_many :containers

  def start_docker_creation_job
    self.delay.create_docker_image
  end

  def create_docker_image
    image = Docker::Image.create('fromImage' => self.repo)
    self.image_id=image.id
    self.ready = true
    self.save
  end
end