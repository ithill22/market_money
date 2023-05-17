Rails.application.routes.draw do

  namespace :api do
    namespace :v0 do
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
      end
    end
  end
end
