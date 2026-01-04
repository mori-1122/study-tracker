Rails.application.routes.draw do
  get "posts/index"
  get "posts/new"
  get "posts/create"
  get "posts/show"
  get "posts/destroy"
  devise_for :users
  root "home#top"
end
