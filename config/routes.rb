Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  namespace :api do
    scope :v1 do
      resources :tracks, only: [:index] do
        member do
          get 'download'
        end
      end

      post 'add_favourtie', action: :add_favourite, controller: 'users'
      delete 'remove_favourtie/:track_id', action: :remove_favourite, controller: 'users'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
