# == Schema Information
#
# Table name: images
#
#  id              :integer          not null, primary key
#  docker_image_id :string
#  name            :string
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repo            :string
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
    begin
      image = Docker::Image.create('fromImage' => self.repo)
      self.docker_image_id = image.id
      self.ready = true
      self.save
    rescue Docker::Error::ArgumentError
      self.destroy #Self destruction : we don't need a useless image
    end
  end
end
