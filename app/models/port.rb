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

class Port < ActiveRecord::Base
  validates_presence_of :host_port, :container_port, :port_type

  belongs_to :container
end
