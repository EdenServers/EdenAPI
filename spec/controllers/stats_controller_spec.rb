require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  it 'should display stats' do
    get 'get_stats'
    expect(response).to have_http_status(:success)
  end
end
