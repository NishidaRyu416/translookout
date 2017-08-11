Rails.application.routes.draw do
  get 'user/show'

  devise_for :users, :controllers => {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :documents
  root to:'welcome#index'
  resources :users
  post "subscription" =>'subscription#create'
  delete "subscription" =>"subscription#destroy"
  post "webhock"=>"webhock#create"
  get    'signup', to: 'users#new'
  resource :lookouts do
    collection do
      get :cover
    end
  end
end
