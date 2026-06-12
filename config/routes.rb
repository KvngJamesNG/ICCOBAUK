Rails.application.routes.draw do
  resources :articles, only: [ :index, :show ]
  resources :articles, only: [] do
    post :verify_email, to: "article_interactions#verify_email"
    post :likes, to: "article_interactions#create_like"
    post :comments, to: "article_interactions#create_comment"
  end

  get "info/:slug", to: "info_pages#show", as: :info_page
  get "data-subject-rights", to: redirect("/info/data-subject-rights")
  post "track-click", to: "tracking#create_click"

  namespace :admin do
    get "login", to: "sessions#new", as: :new_session
    post "session", to: "sessions#create", as: :session
    delete "logout", to: "sessions#destroy", as: :logout
    post "exit", to: "sessions#exit", as: :exit

    root "dashboard#index"
    resources :articles
    resources :article_categories, except: [ :new, :show ]
    resources :authors
    resources :gallery_images
    resources :slider_images
    resources :info_pages
    resource :site_setting, only: [ :show, :edit, :update ]
  end

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
