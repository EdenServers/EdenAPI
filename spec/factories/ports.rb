# == Schema Information
#
# Table name: ports
#
#  id             :integer          not null, primary key
#  host_port      :integer
#  container_port :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  container_id   :integer          default(0)
#  port_type      :string
#

FactoryGirl.define do
  factory :port do
    host_port 25565
    container_port 25565
    port_type "tcp"
    container
  end

end
