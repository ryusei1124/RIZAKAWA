Rails.application.routes.draw do

  #　レッスン関連
  get 'lessons/weeklyschedule'
  post 'lessons/create', to: 'lessons#create'
  #　ユーザー側予約詳細へ
  post 'reservationusers/useredit', to: 'reservationusers#useredit'
  get 'reservationusers/useredit', to: 'reservationusers#useredit'
  post 'reservationusers/usermail', to: 'reservationusers#usermail'
  get 'reservationusers/usermail', to: 'reservationusers#usermail'
  #　ユーザー側予約情報更新
  post 'reservationusers/userupdate', to: 'reservationusers#userupdate'
  get 'reservationusers/reservation_delete', to: 'reservationusers#reservation_delete'
  post 'reservationusers/reservation_change_user', to: 'reservationusers#reservation_change_user'
  post 'reservationusers/reservationnewuser', to: 'reservationusers#reservationnewuser'
  post 'reservationusers/reservationnewusercreate', to: 'reservationusers#reservationnewusercreate'
  # 授業コメント
  post 'lessoncomments/create', to: 'lessoncomments#create'
  # ユーザー側生徒情報更新
  put 'basic_infos/student_update', to: 'basic_infos#student_update'
  # 予約情報から生徒情報更新
  patch 'maneger_students/update', to: 'maneger_students#update'
  
  get 'sessions/new'
  root :to => 'notices#index'
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
