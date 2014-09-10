AirbnbClone::Application.routes.draw do

  devise_for :users

  match '/rate' => 'rater#create', :as => 'rate'

  #resources :orders


  get "pages/howitworks"
    get "spaces/confirm"
#get 'express_checkout', to: 'orders#express_checkout'

  get '/order/express_checkout' => "orders#express_checkout", :as => :pay
  
  resources :orders, :new => { :express_checkout => :get }

  root :to => 'root#root'

#  devise_for :users

resources :comments

  resources :users,    only: [:new, :create, :show, :edit, :update]

  resource  :session,  only: [:new, :create, :destroy] do
    member do
      put "guest_user_sign_in"
    end
  end

  resources :spaces,   only: [:new, :create, :show, :index, :edit, :update, :destroy] do
    resources :bookings, only: [:new, :edit, :index]
  end

  resources :bookings, only: [:index, :create, :show] do
    member do
      put "cancel_by_user"
      put "cancel_by_owner"
      put "decline"
      put "book"
      put "approve"
      put "complete"
    end
  end

  resources :user_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

  resources :space_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

  resources :messages do
    member do
      post :new
    end
    collection do
      get :reply
    end
  end

  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
    collection do
      get :trashbin
      post :empty_trash
      end
    end
  end
