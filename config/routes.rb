Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get '/home', to: 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :doctors, only: [:create,:show,:update,:destroy,:index]
    end
  end
end
