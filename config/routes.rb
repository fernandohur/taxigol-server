TaxigolServer::Application.routes.draw do

  resources :tokens


  resources :companies


  match '/admin' => "home#index"
  match '/' => "home#home"

  resources :drivers do
    collection do
      get 'get_drivers'
      post 'auth'
      post 'reset'
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

  resources :services  do
    collection do
      post 'reset'
    end
  end

  match '/broadcast/user' => 'broadcaster#notify_user', via: :post
  match '/broadcast' => 'broadcaster#broadcast', via: :post 

  match '/requests' => 'requests#index' 

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      resources :companies
      resources :services
      resources :taxis
      resources :apid_users
      resources :apid_drivers
      resources :users do
        collection do
          get 'find'
          post 'notify'
        end
      end

      resources :drivers do
        collection do
          get 'auth'
        end
        member do
          get 'companies'
        end
      end

      resources :positions do
        collection do
          get 'last'
        end
      end

    end
  end
  

end
