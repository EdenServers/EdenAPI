Rails.application.routes.draw do
  resources :containers
  resources :images
  resources :ports
end
