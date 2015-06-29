# == Schema Information
#
# Table name: ports
#
#  id             :integer          not null, primary key
#  host_port      :integer
#  contianer_port :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Port, type: :model do
  describe "Creation" do
    it "should create a port and add a container to it" do
      port = FactoryGirl.create(:port)
      image = FactoryGirl.create(:image_with_container)
      container = image.containers.last
      port.container = container

      expect(port.container).to be container
    end
  end
end
