Rails.application.routes.draw do
  devise_for :users

  namespace :blogs do
    root 'posts#index'
    get 'posts/new', to: 'posts#new'
    get 'posts/:id', to: 'posts#show'
    get 'posts/edit/:id', to: 'posts#edit'
    post 'posts', to: 'posts#create'
  end
end
