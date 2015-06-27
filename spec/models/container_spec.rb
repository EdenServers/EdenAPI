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

require 'rails_helper'

RSpec.describe Container, type: :model do
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
      container.docker_container_id = "random"
      container.start
      expect(container.get_docker_object).to be_nil
    end

    it "shouldn't work if it's already running" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.start
      container.start
      expect(container.get_docker_object.json['State']['Running']).to be_truthy
    end

    it "should start the container" do
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      container.start
      expect(container.get_docker_object.json['State']['Running']).to be_truthy
    end
  end

  
end