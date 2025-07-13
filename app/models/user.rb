# app/models/user.rb
class User < ApplicationRecord
  # Deviseモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   has_many :prototypes, dependent: :destroy
   has_many :comments, dependent: :destroy

  # 空チェック（１行ずつ）
  validates :name,       presence: true
  validates :profile,    presence: true
  validates :occupation, presence: true
  validates :position,   presence: true

  # パスワードは6文字以上
  validates :password, length: { minimum: 6 }, allow_blank: true
end
