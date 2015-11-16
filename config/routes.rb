Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  # root "home#home"
  root "posts#index"
  get "/about" => "home#about"

  # for tags
  get 'tags/:tag', to: 'posts#index', as: "tag"

  # routes for blog posts and user comments on a blog post
  resources :posts do
    resources :comments
  end

  # routes for user Sign-Up
  resources :users, only:[:new, :create]

  # routes for user Sign-in and Log-out
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  # routes for category
  resources :categories
end
