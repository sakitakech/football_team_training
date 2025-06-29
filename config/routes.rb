Rails.application.routes.draw do
  resources :teams, only: [ :new, :create, :show, :edit, :update, :destroy ] do
    member do
      get :confirm_destroy
    end
  end
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  devise_scope :user do
    get "users/confirm_delete", to: "users/registrations#confirm_delete", as: :confirm_delete_user
    get "users/sign_up/member", to: "users/registrations#new_member", as: :new_member_registration
  end

  get "/users/complete_profile", to: "users#complete_profile", as: :complete_profile
  patch "/users/complete_profile", to: "users#update_profile"



  resources :users, only: [ :new, :index, :show, :update ] do
    resources :trainings, only: [ :index ]
    member do
      patch :remove_from_team
      patch :promote_admin
      patch :transfer_admin
      patch :demote_admin
      patch :self_promote_admin
    end
    collection do
      patch :leave_team
    end
  end

  get "profile/edit", to: "users#edit", as: :edit_profile

  resources :trainings

  get "up" => "rails/health#show", as: :rails_health_check


  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "static_pages#top"
  get "/privacy", to: "static_pages#privacy"
  get "/terms_of_service", to: "static_pages#terms_of_service"
  get "/how_to_use", to: "static_pages#how_to_use"

  resources :charts, only: [ :index ]

  namespace :api do
    get "charts/max_weights", to: "charts#max_weights"
    get "charts/body_metrics", to: "charts#body_metrics"
  end

  get "calendar", to: "calendar#index"

  namespace :api do
    get "calendar/histories", to: "calendar#histories"
  end

  resources :team_invitations, only: [ :new ]
  resources :team_join_requests, only: [ :new, :create, :index, :update ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
