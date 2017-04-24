Rails.application.routes.draw do

  get 'admin/allusers'
  get 'admin/allnotes'
  get 'admin/allcourses' => "admin#allcourses"
  put 'admin/deactivate/:id' => "admin#toggle_deactivate"
  put 'admin/privilege/:id' => "admin#update_privilege"

  get 'favorites/index'

  get 'tags/index'

  get 'tags/new'

  get 'tags/create'

  get 'tags/show'

  get 'courses/index'

# PLURAL NOTES CONTROLLER?

  root "main#index"
  get 'courses' => 'courses#index'
  get 'courses/new' => "courses#new"

  post 'courses' => "courses#create"
  get 'courses/:course_id' => 'courses#show'
  delete 'courses/:id' => "courses#destroy"
  get 'courses/:id/edit' => "courses#edit"
  put 'courses/:id/edit' => "courses#update"

  get 'notes' => 'notes#index'
  get 'signup' => "user#new"
  post 'signup' => "user#create"
  get 'login' => "sessions#new"
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy"
  get 'find/:id' => "tags#show"
  get 'profile' => "user#index"
  post 'profile' => "user#update"
  get 'notes/new' => "notes#new"
  post 'notes/new' => "notes#create"
  get 'notes/:id/edit' => "notes#edit"
  put 'notes/:id/edit' => "notes#update"
  put 'publish/:id' => "notes#publish"
  put 'makeprivate/:id' => "notes#make_private"
  put 'notes/:id' => 'notes#add_to_white_list'
  get 'notes/:id' => 'notes#show'
  post 'notes/:id' => 'favorites#create'
  get 'profile/:id' => 'user#show'
  get 'favorites' => 'favorites#index'
  delete 'favorites/:id' => "favorites#destroy"
  post 'comments' => "comments#create"
  delete 'comments/:id' => "comments#destroy"
  delete 'tags/:note_id/:tag_id' => "tags#destroy"
  put 'notes/vote/:isDown/:id' => "notes#vote"
  put 'comments/vote/:isDown/:id' => "comments#vote"
  resources :users
  resources :notes

end
