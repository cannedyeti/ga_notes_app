Rails.application.routes.draw do

# PLURAL NOTES CONTROLLER?

  root "main#index"
  get 'notes' => 'notes#index'
  get 'find/:category' => 'notes#show'
  get 'signup' => "user#new"
  post 'signup' => "user#create"
  get 'login' => "sessions#new"
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy"
  get 'find/:tag' => "notes#show"
  get 'profile' => "user#index"
  get 'profile/edit' => "user#edit"
  post 'profile/edit' => "user#update"
  get 'notes/new' => "notes#new"
  post 'notes/new' => "notes#create"
  get 'notes/:id/edit' => "notes#show"
  put 'notes/:id/edit' => "notes#update"
  get 'notes/:id' => 'notes#show'
  get 'profile/:id' => 'user#show'
  get 'favorites' => 'user#index'




  resources :users
  resources :notes

end
