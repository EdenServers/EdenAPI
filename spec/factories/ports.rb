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

FactoryGirl.define do
  factory :port do
    host_port 1
contianer_port 1
  end

end
