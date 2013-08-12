TaxigolServer::Application.routes.draw do

  resources :drivers do
    collection do
      get 'get_drivers'
      post 'auth'
      post 'reset'
    end
  end

  resources :map_objects do
    collection do
      post 'reset'
      post 'expire'
    end
  end

  resources :positions do
    collection do
      post 'reset'
      get 'get_last'
    end
  end

  resources :taxis do
    collection do
      post 'reset'
      post 'auth'
    end
  end

  resources :users do
    collection do
      post 'reset'
    end
  end

  resources :panics do
    collection do
      post 'reset'
    end
  end

  resources :services  do
    collection do
      post 'reset'
    end
  end

  match '/broadcast' => 'broadcaster#broadcast', via: :post  

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :services
      resources :positions
      resources :drivers do
        collection do
          get 'auth'
        end
      end
      resources :taxis
    end
  end
  

end
