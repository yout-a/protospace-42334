# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    context 'メール関連' do
      it 'メールアドレスが必須であること' do
        subject.email = ''
        subject.valid?
        expect(subject.errors[:email]).to include 'を入力してください'
      end

      it 'メールアドレスが一意であること' do
        create(:user, email: subject.email)
        subject.valid?
        expect(subject.errors[:email]).to include 'はすでに存在します'
      end

      it 'メールアドレスに @ を含むこと' do
        subject.email = 'invalid.email'
        subject.valid?
        expect(subject.errors[:email]).to include 'は不正な値です'
      end
    end

    context 'パスワード関連' do
      it 'パスワードは6文字以上であること' do
        subject.password = 'a' * 5
        subject.password_confirmation = subject.password
        subject.valid?
        expect(subject.errors[:password]).to include 'は6文字以上で入力してください'
      end
    end

    context 'ユーザー情報' do
      it 'ユーザー名が必須であること' do
        subject.name = ''
        subject.valid?
        expect(subject.errors[:name]).to include 'を入力してください'
      end

      it 'プロフィールが必須であること' do
        subject.profile = ''
        subject.valid?
        expect(subject.errors[:profile]).to include 'を入力してください'
      end

      it '所属(occupation)が必須であること' do
        subject.occupation = ''
        subject.valid?
        expect(subject.errors[:occupation]).to include 'を入力してください'
      end

      it '役職(position)が必須であること' do
        subject.position = ''
        subject.valid?
        expect(subject.errors[:position]).to include 'を入力してください'
      end
    end
  end
end
