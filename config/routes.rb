Rails.application.routes.draw do
  resources :products
  devise_for :users
  root 'pages#home'

  post "products/:id/order", to: "products#place_order", as: "place_order"

  get 'pages/success', to: 'pages#success', as: "order_success"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
