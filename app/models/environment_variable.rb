class EnvironmentVariable < ActiveRecord::Base
  belongs_to :container

  validates_presence_of :key, :value
end
