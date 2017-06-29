Rails.application.routes.draw do
  get 'users/sign_in'
  post 'users/sign_up'
  get 'users/sign_out'
  get 'users/send_support_email'
  post 'users/save_notification_token'
  get 'users/my_help_requests'

  resources :contacts, only: [:create, :index] do
    collection do
      get 'open_requests'
    end

    get 'drop_contact'
    get 'refuse_request'
    get 'accept_request'
  end

  resources :notifications, only: [:index, :create] do
    collection do
      put ':code' => 'notifications#update'
      patch ':code' => 'notifications#update'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#home'
end
