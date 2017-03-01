Rails.application.routes.draw do
  resources :charges, only: [:new, :create]

  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end

  devise_for :users

  get 'downgrade' => 'charges#downgrade'

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
