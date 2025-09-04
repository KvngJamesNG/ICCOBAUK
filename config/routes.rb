Rails.application.routes.draw do
  get 'home', to: 'pages#home'
  get 'contact_us', to: 'pages#contact_us'
  get 'blog_post', to: 'pages#blog_post'
  get 'blog_home', to: 'pages#blog_home'
  get 'about_us', to: 'pages#about_us'
  get 'faq', to: 'pages#faq'
  get 'portfolio_item', to: 'pages#portfolio_item'
  get 'portfolio_overview', to: 'pages#portfolio_overview'
  get 'events', to: 'pages#events'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
