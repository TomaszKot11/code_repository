# frozen_string_literal: true

Rails.application.routes.draw do
  scope defaults: { format: 'json' } do
    resources :events, only: %i(index show)

    namespace :api do
      namespace :v1 do
        resources :reservations, only: :create
      end
    end

    resources :tickets, only: %i(index) do
      member do
        post :buy # performing on ticket resource so id in the URL
      end
    end
  end
end
