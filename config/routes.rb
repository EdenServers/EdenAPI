Rails.application.routes.draw do
  namespace :api do
    resources :containers
    resources :images
  end
end
