# テーブル設計

## users テーブル

| Column             | Type   | Options                           |
|--------------------|--------|-----------------------------------|
| email              | string | null: false, unique: true         |
| encrypted_password | string | null: false                       |
| name               | string | null: false                       |
| profile            | text   | null: false                       |
| occupation         | text   | null: false                       |
| position           | text   | null: false                       |

### Association（アソシエーション）

- has_many :prototypes  
  → ユーザーは複数のプロトタイプを投稿できる
- has_many :comments  
  → ユーザーは複数のコメントを投稿できる

---

## prototypes テーブル

| Column     | Type       | Options                           |
|------------|------------|-----------------------------------|
| title      | string     | null: false                       |
| catch_copy | text       | null: false                       |
| concept    | text       | null: false                       |
| user       | references | null: false, foreign_key: true    |

※ `image` は ActiveStorage で実装するため含まない。

### Association（アソシエーション）

- belongs_to :user  
  → プロトタイプは1人のユーザーに属する
- has_many :comments  
  → プロトタイプには複数のコメントが付けられる

---

## comments テーブル

| Column    | Type       | Options                           |
|-----------|------------|-----------------------------------|
| content   | text       | null: false                       |
| prototype | references | null: false, foreign_key: true    |
| user      | references | null: false, foreign_key: true    |

### Association（アソシエーション）

- belongs_to :user  
  → コメントは1人のユーザーに属する
- belongs_to :prototype  
  → コメントは1つのプロトタイプに属する
