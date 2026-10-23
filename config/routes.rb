Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "articles#index"
  resources :articles do
    member do
      patch :comment_visibility
    end
    resources :comments
  end
end
