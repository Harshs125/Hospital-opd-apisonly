Rails.application.routes.draw do
  devise_for :users,:skip => [:registrations] ,controllers: {
    sessions: 'users/sessions',
    # regisrations: 'users/registrations'
  }
  get "up" => "rails/health#show", as: :rails_health_check
  get '/home', to: 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :doctors do
        collection do
          post:register_doctor
          post:suspend_doctor
        end
      end
      resources :services, only:[:create,:show,:update,:destroy,:index]
      resources :patients do
        resources:patient_records, only: [:index,:create]
      end
      resources:patient_records,except: [:index,:create]
    end
  end
end
