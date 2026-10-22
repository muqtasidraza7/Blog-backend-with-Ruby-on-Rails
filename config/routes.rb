Rails.application.routes.draw do
  root "articles#index"
  resources :articles do
    member do
      patch :comment_visibility 
    end
    resources :comments
  end
end
