Rails.application.routes.draw do
  get 'users/show'
  # トップページ
  root to: 'prototypes#index'

  # Devise のユーザー認証
  devise_for :users

  # 投稿者プロフィール（show）用
  resources :users, only: [:show]

  # プロトタイプとコメント
  resources :prototypes do
    resources :comments, only: [:create, :destroy, :edit, :update]
  end
end
