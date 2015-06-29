# == Schema Information
#
# Table name: ports
#
#  id             :integer          not null, primary key
#  host_port      :integer
#  container_port :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :port do
    host_port 25565
    container_port 25565
    port_type "tcp"
  end

end
