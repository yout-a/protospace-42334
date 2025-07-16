# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    # 一意のメールアドレスを生成
    sequence(:email) { |n| "user#{n}@example.com" }

    # Devise の必須パスワード類
    password { "password" }
    password_confirmation { "password" }

    # モデルスペックでチェックしている必須属性
    name       { "テスト太郎" }
    profile    { "これはテスト用のプロフィールです。" }
    occupation { "テスト株式会社" }
    position   { "エンジニア" }
  end
end

