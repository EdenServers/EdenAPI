require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  after(:each) do
    #Cleanup docker
    Container.all.each { |container| container.destroy }
  end

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
    it "should return an error if image is nil" do
      params = {
          image_id: nil
      }

      post 'create', container: params
      expect_status(500)
    end

    it "should return an image if params are valids" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id,
          name: 'minecraft'
      }

      post 'create', container: params
      expect_status(200)
    end

    it "should return an error if params are not valids" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id,
      }

      post 'create', container: params
      expect_status(500)
    end

    it "should not work if the image isn't ready" do
      image = FactoryGirl.create(:image)
      image.ready = false

      params = {
          image_id: image.id,
          name: 'minecraft',
          ports: "[{\"host_port\": 25565, \"container_port\": 25565, \"port_type\": \"tcp\"}]"
      }

      post 'create', container: params

      expect_status(500)
      expect_json({ error: "image_not_ready" })
    end

    it "should create a number of environment variables if params are valid and variables are given" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id,
          name: 'minecraft',
          environment_variables: "[{\"key\": \"test\", \"value\": \"test\"}]"
      }

      post 'create', container: params

      expect(Container.last.environment_variables).not_to be_empty
      expect(Container.last.environment_variables.last.key).to be == "test"
      expect(Container.last.environment_variables.last.value).to be == "test"

      expect_status(200)
    end

    it "should map a number of ports if params are valids and ports are given" do
      FactoryGirl.create(:image_with_container)
      params = {
          image_id: Container.last.image_id,
          name: 'minecraft',
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

  describe "GET /containers/:container_id/start" do
    it "should return a 500 error if it can't find the container" do
      get 'start', container_id: 69
      expect_status(500)
    end

    it "should start the container" do
      FactoryGirl.create(:image_with_container)
      get 'start', container_id: Container.last.id

      expect_status(200)
      expect(Container.last.get_docker_object.json['State']['Running']).to be_truthy
    end
  end

  describe "GET /containers/:container_id/stop" do
    it "should return a 500 error if it can't find the container" do
      get 'stop', container_id: 69
      expect_status(500)
    end

    it "should start the container" do
      FactoryGirl.create(:image_with_container)
      Container.last.start
      get 'stop', container_id: Container.last.id

      expect_status(200)
      expect(Container.last.get_docker_object.json['State']['Running']).to_not be_truthy
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

  describe "GET /containers/:id" do
    it "shoud show a container" do
      FactoryGirl.create(:image_with_container)
      get :show, id: Container.last.id

      expect_json({ name: "Test Container" })
      expect_status(200)
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