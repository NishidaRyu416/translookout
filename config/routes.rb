Rails.application.routes.draw do

  root to:'welcome#index'

  resource :lookouts do
    collection do
      get :cover
    end
  end
end
