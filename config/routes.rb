Rails.application.routes.draw do
  resources :containers do
    get '/start' => 'containers#start'
    get '/stop' => 'containers#stop'
  end

  resources :images
  resources :ports do
    get 'check' => 'ports#check_port'
  end

  get '/stats' => 'stats#get_stats'
end
