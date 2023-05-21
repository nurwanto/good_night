Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'bed_time' => 'bed_time#history'
      get 'bed_time/:user_id' => 'bed_time#history'
      post 'bed_time/set_unset' => 'bed_time#set_unset'

      post 'follow' => 'follow#action'
      get 'follow/followers' => 'follow#get_followers'
      get 'follow/followed' => 'follow#get_followed'
    end
  end
end
