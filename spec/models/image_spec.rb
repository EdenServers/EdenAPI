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

require 'rails_helper'

RSpec.describe Image, type: :model do
  describe "Create Docker Image" do
    it "shouldn't save if repo is wrong" do
      image_count = Image.count
      image = FactoryGirl.create(:image_wrong_repo)
      image.create_docker_image
      expect(Image.count).to eq(image_count)
    end

    it "Should save the correct docker_image_id and switch on ready" do
      docker_image =  Docker::Image.create("fromImage" => "dernise/minecraft")
      image = FactoryGirl.create(:image)
      image.create_docker_image
      expect(image.ready).to be true
      expect(image.docker_image_id).to eq(docker_image.id)
    end
  end
end
