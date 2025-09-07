Rails.application.routes.draw do
  get 'home', to: 'pages#home'
  get 'contact_us', to: 'pages#contact_us'
  get 'blog_post', to: 'pages#blog_post'
  get 'blog_post2', to: 'pages#blog_post2'
  get 'blog_post3', to: 'pages#blog_post3'
  get 'blog_post4', to: 'pages#blog_post4'
  get 'blog_home', to: 'pages#blog_home'
  get 'about_us', to: 'pages#about_us'
  get 'faq', to: 'pages#faq'
  get 'portfolio_item', to: 'pages#portfolio_item'
  get 'portfolio_item2', to: 'pages#portfolio_item2'
  get 'portfolio_item3', to: 'pages#portfolio_item3'
  get 'portfolio_overview', to: 'pages#portfolio_overview'
  get 'events', to: 'pages#events'
 
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
