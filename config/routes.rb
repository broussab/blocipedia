Rails.application.routes.draw do
  resources :charges, only: [:new, :create]

  resources :wikis

  devise_for :users

  get 'downgrade' => 'charges#downgrade'

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
