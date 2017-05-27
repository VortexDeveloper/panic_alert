Rails.application.routes.draw do
  get 'users/sign_in'
  post 'users/sign_up'
  get 'users/sign_out'
  get 'users/send_support_email'

  resources :contacts, only: [:create, :index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#home'
end
