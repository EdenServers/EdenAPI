Rails.application.routes.draw do
  resources :containers do
    get '/start' => 'containers#start'
    get '/stop' => 'containers#stop'
  end

  resources :images
  resources :ports
  get '/ports/check/:id' => 'ports#check_port'

  get '/stats' => 'stats#get_stats'
end
