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
  describe "Starting container" do
    it "shouldn't start if container is nil" do

    end
  end
end
