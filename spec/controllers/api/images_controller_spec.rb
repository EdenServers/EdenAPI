require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe "GET /containers" do
    it "should list all images" do
      FactoryGirl.create(:image)
      FactoryGirl.create(:image)
      get 'index'
      expect_status(200)
      expect_json_sizes(2)
    end
  end

  describe "POST /containers" do
    it "should return an error if params are not valids" do
      params = {
          repo: nil,
          name: nil
      }

      post 'create', image: params
      expect_status(500)
    end

    it "should return a container if params are valids" do
      params = {
          repo: "dernise/mincraft",
          name: "Minecraft"
      }

      post 'create', image: params
      expect_status(200)
    end
  end
end
