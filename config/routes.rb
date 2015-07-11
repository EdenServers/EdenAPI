Rails.application.routes.draw do
  apipie

  root 'apipie/apipies#index'

  resources :containers
  resources :images
  resources :ports
end
