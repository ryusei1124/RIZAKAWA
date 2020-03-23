Rails.application.routes.draw do



  get '/attendances/lesson_detail/:lesson_id' ,to: 'attendances#lesson_detail'
  get 'lessons/weeklyschedule'
  post 'lessons/create', to: 'lessons#create'
  post 'reservationusers/useredit', to: 'reservationusers#useredit'
  get 'reservationusers/useredit', to: 'reservationusers#useredit'
  post 'reservationusers/userupdate', to: 'reservationusers#userupdate'
  post 'reservationusers/reservation_change_user', to: 'reservationusers#reservation_change_user'
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
  resources :reservations
end
