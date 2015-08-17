require 'rails_helper'

RSpec.describe PortsController, type: :controller do
  let(:image_with_container) { FactoryGirl.create(:image_with_container) }

  after(:each) do
    #Cleanup docker
    Container.all.each { |container| container.destroy }
  end

  describe "GET /ports" do
    it "should get a list of ports" do
      FactoryGirl.create(:port, container: image_with_container.containers.last)

      get 'index'

      expect_status(200)
      expect_json_sizes(2)
      parsed_json = JSON(response.body)
      expect(parsed_json.last['container']).to_not be(nil)
    end
  end


  describe "POST /ports" do
    it "should return an error if container_id is nil" do
      params = {
          container_id: nil
      }

      post 'create', port: params
      expect_status(500)
    end

    it "should return an error if params are not valids" do
      params = {
          container_id: image_with_container.containers.last.id,
          host_port: nil,
          container_port: nil,
          port_type: nil
      }

      post 'create', port: params
      expect_status(500)
    end

    it "should create a port if params are valid" do
      params = {
          container_id: image_with_container.containers.last.id,
          host_port: 25565,
          container_port: 25565,
          port_type: 'tcp'
      }

      post 'create', port: params
      expect_status(200)
    end
  end

  describe "PUT /ports/:id" do
    it "should return a 500 error if it can't find the object" do
      params = {
          host_port: 2222,
      }

      put 'update', id: 69, port: params
      expect_status(500)
    end

    it "should update the port if params are valid" do
      port = FactoryGirl.create(:port, container: image_with_container.containers.last)
      params = {
          host_port: 2555,
      }

      put 'update', id: port.id, port: params
      expect_status(200)
      expect_json({ host_port: 2555 })
    end
  end

  describe "GET /ports/:id" do
    it "should show a port" do
      port = FactoryGirl.create(:port, container: image_with_container.containers.last)
      get :show, id: port.id

      expect_json({ host_port: 25565 })
      expect_status(200)
      parsed_json = JSON(response.body)
      expect(parsed_json['container']).to_not be(nil)
    end

    it "should display an error if the port wasn't found" do
      get :show, id: 69

      expect_status(500)
    end
  end

  describe "DELETE /ports/:id" do
    it "should return 500 if it can't find a port" do
      delete 'destroy', id: 69
      expect_status(500)
    end

    it "should destroy the port if found" do
      port = FactoryGirl.create(:port, container: image_with_container.containers.last)
      delete 'destroy', id: port.id
      expect_status(200)
    end
  end

end
