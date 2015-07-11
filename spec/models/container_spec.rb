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

require 'rails_helper'

RSpec.describe Container, type: :model do
  after(:each) do
    #Cleanup docker
    Container.all.each { |container| container.destroy }
  end

  describe "Creation" do
    it "should add a docker_container_id after its creation" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      expect(container.docker_container_id).to_not be_nil
    end
  end

  describe "Deletion" do
    it "should delete the container" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.destroy
      expect(container.destroyed?).to be_truthy
    end
  end

  describe "Start" do
    it "shouldn't work if container variable is nil" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last

      #Simulate like the are no attached containers
      docker_container_id = container.docker_container_id
      container.docker_container_id = 'wrongid'

      container.start
      expect(container.get_docker_object).to be_nil

      container.docker_container_id = docker_container_id #Clean up
    end

    it "shouldn't work if it's already running" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.start
      container.start
      expect(container.get_docker_object.json['State']['Running']).to be_truthy
      container.stop
    end

    it "should start the container" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.start
      expect(container.get_docker_object.json['State']['Running']).to be_truthy
      container.stop
    end
  end

  describe "Stop" do
    it "shouldn't stop the container if its not running" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.stop
      expect(container.get_docker_object.json['State']['Running']).to be_falsey
    end

    it "shouldn't stop the container if its running" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.start
      container.stop
      expect(container.get_docker_object.json['State']['Running']).to be_falsey
    end
  end
end
