Rails.application.routes.draw do
  devise_for :users

  namespace :blogs do
    root 'posts#index'
    get 'posts/new', to: 'posts#new'
  end
end
