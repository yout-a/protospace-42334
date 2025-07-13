# app/models/prototype.rb
class Prototype < ApplicationRecord
  # user テーブルとの関連付け（外部キー user_id）
  belongs_to :user

  # コメントも持つなら
  has_many :comments, dependent: :destroy

 # ①メインの１枚だけをサムネイルとして扱いたい場合
  has_one_attached :image

  # バリデーション
  validates :title,      presence: true, length: { maximum: 255 }
  validates :catch_copy, presence: true
  validates :concept,    presence: true
end
