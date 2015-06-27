require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  describe "GET /api/containers" do
    it 'should return all the containers' do
      get '/containers'
      expect_status(200)
    end
  end
end