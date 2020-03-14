Rails.application.routes.draw do

  get '/attendances/lesson_detail/:lesson_id' ,to: 'attendances#lesson_detail'
  get 'lessons/weeklyschedule'
  post 'lessons/create', to: 'lessons#create'
  post 'reservations/useredit', to: 'reservations#useredit'
  get 'reservations/useredit', to: 'reservations#useredit'
  post 'reservations/userupdate', to: 'reservations#userupdate'
  get 'sessions/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'reservations/reservations_log'
    end
  end
  
  resources :notices
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
