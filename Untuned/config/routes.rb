Rails.application.routes.draw do
  get 'topics/index'
  get 'profiles/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'users/:username', to: 'users#show', as: 'user'
  

  resources :users, only: :show, param: :username do
    member do
      get 'follow', to: 'follows#create1'
      get 'unfollow', to: 'follows#destroy1'
    end
  end

  resources :posts do
    member do
      get 'like', to: 'votes#createlike'
      get 'unlike', to: 'votes#destroylike'

      get 'dislike', to: 'votes#createdislike'
      get 'undislike', to: 'votes#destroydislike'

      get 'followpost', to: 'follows#create2'
      get 'unfollowpost', to: 'follows#destroy2'

    end

    resources :comments do
      member do
        get 'like', to: 'votes_comment#createlike'
        get 'unlike', to: 'votes_comment#destroylike'
  
        get 'dislike', to: 'votes_comment#createdislike'
        get 'undislike', to: 'votes_comment#destroydislike'
      end
    end
  end


  
  devise_for :users
  as:user do 
    get 'signin', to: 'devise/sessions#new'
    get 'signout', to: 'devise/sessions#destroy'
    get 'signup', to: 'devise/registrations#new'
    get 'edit_user', to: 'devise/registrations#edit'
    get 'delete_user', to: 'devise/registrations#destroy'
  end

  root 'pages#home'
  get 'contact', to: 'pages#contact'
  get 'posts', to: 'posts#index'
  get 'oldest_posts', to: 'posts#oldest'
  get 'newest_following_posts', to: 'posts#newest_following'
  get 'oldest_following_posts', to: 'posts#oldest_following'
  get 'admin', to: 'root#admin'

  get 'followers', to: 'users#followers'
  get 'following', to: 'users#following'

end
