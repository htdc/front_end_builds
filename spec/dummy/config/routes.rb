Rails.application.routes.draw do
  front_end :dummy

  resources :items, only: [:show]

  mount FrontEndBuilds::Engine, at: '/frontend-config'

  get '/123' => 'welcome#index'
end
