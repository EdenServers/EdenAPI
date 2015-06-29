require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  describe "GET /containers" do
    it "should list all images" do
      FactoryGirl.create(:image_with_container)
      FactoryGirl.create(:image_with_container)
      get 'index'
      expect_status(200)
      expect_json_sizes(2)
    end
  end

  describe "POST /containers" do
    it "should return an error if params are not valids" do
      params = {
          image_id: nil
      }

      post 'create', container: params
      expect_status(500)
    end

    it "should return an image if params are valids" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id
      }

      post 'create', container: params
      expect_status(200)
    end

    it "should map a number of ports if params are valids and ports are given" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id,
          ports: "[{\"host_port\": 25565, \"container_port\": 25565, \"port_type\": \"tcp\"}]"
      }

      post 'create', container: params

      expect(Container.last.ports).not_to be_empty
      expect(Container.last.ports.last.host_port).to equal(25565)
      expect(Container.last.ports.last.container_port).to equal(25565)
      expect(Container.last.ports.last.port_type.to_s).to be == "tcp"
      expect_status(200)
    end
  end

  describe "PUT /containers/:id" do
    it "should return a 500 error if it can't find the object" do
      params = {
          name: "Test",
      }

      put 'update', id: 69, container: params
      expect_status(500)
    end

    it "should update the image if params are valids" do
      FactoryGirl.create(:image_with_container)
      params = {
          name: "Test",
      }

      put 'update', id: Container.last.id, container: params
      expect_status(200)
      expect_json({ name: "Test" })
    end
  end

  describe "DELETE /containers/:id" do
    it "should return 500 if it can't find a container" do
      delete 'destroy', id: 69
      expect_status(500)
    end

    it "should destroy the container if found" do
      FactoryGirl.create(:image_with_container)
      delete 'destroy', id: Container.last.id
      expect_status(200)
    end
  end
end