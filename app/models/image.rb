# == Schema Information
#
# Table name: images
#
#  id              :INTEGER          not null, primary key
#  docker_image_id :varchar
#  name            :varchar
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repo            :varchar
#  ready           :boolean          default(FALSE)
#

class Image < ActiveRecord::Base
  after_create :start_docker_creation_job

  validates_presence_of :repo, :name

  has_many :containers

  def start_docker_creation_job
    self.delay.create_docker_image
  end

  def create_docker_image
    image = Docker::Image.create('fromImage' => self.repo)
    self.docker_image_id=image.id
    self.ready = true
    self.save
  end
end
