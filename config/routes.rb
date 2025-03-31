Rails.application.routes.draw do
  resources :trainings
  devise_for :users,controllers: {
    trainings: 'users/trainigs'
  }

  get "up" => "rails/health#show", as: :rails_health_check


  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "static_pages#top"
end

