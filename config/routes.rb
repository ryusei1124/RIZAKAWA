Rails.application.routes.draw do

  get 'lessons/weeklyschedule'
  post 'lessons/create', to: 'lessons#create'
  post 'reservationusers/useredit', to: 'reservationusers#useredit'
  get 'reservationusers/useredit', to: 'reservationusers#useredit'
  post 'reservationusers/userupdate', to: 'reservationusers#userupdate'
  get 'reservationusers/reservation_delete', to: 'reservationusers#reservation_delete'
  post 'reservationusers/reservation_change_user', to: 'reservationusers#reservation_change_user'
  post 'reservationusers/reservationnewuser', to: 'reservationusers#reservationnewuser'
  post 'reservationusers/reservationnewusercreate', to: 'reservationusers#reservationnewusercreate'
  get 'sessions/new'
  post 'lessoncomments/create', to: 'lessoncomments#create'
  root :to => 'notices#index'
  #root 'static_pages#top'
  get '/signup', to: 'users#new'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # ログインボタン(管理者、生徒)
  patch 'login', to: 'sessions#admin_login'
  put 'login', to: 'sessions#student_login'

  resources :users do
    member do
      get 'reservations/reservations_log'
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
  end

  resources :lessons do
   member do
     get 'lesson_detail'
     patch 'lesson_detail'
     get 'lesson_discontinuation_fix'
     patch 'lesson_discontinuation_fix'
     get 'add_student'
     patch 'add_student'
   end
  end
  resources :notices
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :reservations, only: :update
end
