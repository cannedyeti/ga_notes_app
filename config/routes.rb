Rails.application.routes.draw do

  get 'courses/index'

# PLURAL NOTES CONTROLLER?

  root "main#index"
  get 'courses' => 'courses#index'
  get 'notes' => 'notes#index'
  get 'courses/:course_id' => 'courses#show'
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
