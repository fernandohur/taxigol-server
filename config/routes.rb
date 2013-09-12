TaxigolServer::Application.routes.draw do

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

<<<<<<< HEAD
  resources :panics do
=======
  resources :apid_user do
>>>>>>> 2f87340badeffa022cc11945b696aeb6ceabf150
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

      resources :services

      resources :positions
<<<<<<< HEAD
      resources :apid_users
=======

>>>>>>> 2f87340badeffa022cc11945b696aeb6ceabf150
      resources :users

      resources :drivers do
        collection do
          get 'auth'
        end
      end

      resources :taxis
    end
  end
  

end
