Rails.application.routes.draw do
  resources :teams, only: [ :new, :create, :show, :edit, :update, :destroy ]

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  devise_scope :user do
    get "users/confirm_delete", to: "users/registrations#confirm_delete", as: :confirm_delete_user
    get "users/sign_up/member", to: "users/registrations#new_member", as: :new_member_registration
    get "users/sign_up/admin", to: "users/registrations#new_admin", as: :new_admin_registration
  end


  resources :users, only: [ :new, :index, :show, :update ]
  get "profile/edit", to: "users#edit", as: :edit_profile

  resources :trainings

  get "up" => "rails/health#show", as: :rails_health_check


  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "static_pages#top"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
