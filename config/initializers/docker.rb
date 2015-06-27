require 'docker'

Docker.url = ENV['DOCKER_URL'] ||= "unix:///var/docker.sock" unless Rails.env.production?