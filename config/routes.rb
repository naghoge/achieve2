Rails.application.routes.draw do

  get 'notifications/index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  #resources :blogs, only: [:index, :new, :create, :edit, :update, :destroy, :show]do
  #  collection do
  #    post :confirm
  #  end
  # end
  
  resources :conversations do
    resources :messages
  end
  
  resources :blogs do
    resources :comments
    post :confirm, on: :collection
  end
  
   devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  resources :users, only: [:index, :show]
  resources :poems, only: [:index, :show]

  resources :contacts, only: [:new, :create]do
    collection do
      post :confirm
    end
  end
  
  resources :relationships, only: [:create, :destroy]
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

    root 'top#index'
end
