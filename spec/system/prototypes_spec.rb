# spec/system/prototypes_spec.rb
require 'rails_helper'

RSpec.describe 'プロトタイプ投稿機能', type: :system do
  before do
    driven_by :rack_test
  end

  let(:user) { create(:user) }

  describe '投稿ページへのアクセス制御' do
    context 'ログインしているユーザー' do
      it '投稿ページに遷移できること' do
        sign_in user
        visit new_prototype_path
        expect(current_path).to eq new_prototype_path
        expect(page).to have_content '新規プロトタイプ投稿'
      end
    end

    context 'ログインしていないユーザー' do
      it '投稿ページにアクセスするとログイン画面にリダイレクトされること' do
        visit new_prototype_path
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'プロトタイプの作成' do
    before do
      sign_in user
      visit new_prototype_path
    end

    context '必要情報をすべて入力している場合' do
      it 'トップページに遷移し、投稿内容が表示されること' do
        fill_in 'プロトタイプの名称', with: 'My Prototype'
        fill_in 'キャッチコピー',     with: 'This is a catch copy'
        fill_in 'コンセプト',         with: 'Prototype concept'
        attach_file 'プロトタイプの画像', Rails.root.join('spec/fixtures/files/test_image.png')
        click_button '保存する'

        expect(current_path).to eq root_path
        within '.prototypes-list' do
          expect(page).to have_selector("img[src*='test_image.png']")
          expect(page).to have_content 'My Prototype'
          expect(page).to have_content 'This is a catch copy'
          expect(page).to have_content user.name
        end
      end
    end

    context '必須情報が未入力の場合' do
      it '同じページに留まり、入力済みの情報は保持されること' do
        fill_in 'プロトタイプの名称', with: 'Incomplete'
        attach_file 'プロトタイプの画像', Rails.root.join('spec/fixtures/files/test_image.png')
        click_button '保存する'

        expect(page).to have_current_path prototypes_path
        expect(page).to have_content 'キャッチコピーを入力してください'
        expect(find_field('プロトタイプの名称').value).to eq 'Incomplete'
        expect(page).not_to have_selector("img[src*='test_image.png']")
      end
    end
  end

  describe 'トップページの表示内容' do
    let!(:prototype) do
      create(:prototype,
             user: user,
             title: 'Demo',
             catch_copy: 'Catch!',
             concept: 'Concept',
             image: fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png'))
    end

    it '投稿一覧に画像・名称・キャッチコピー・投稿者名が表示されること' do
      visit root_path
      within "#prototype_#{prototype.id}" do
        expect(page).to have_selector("img[src*='test_image.png']")
        expect(page).to have_content 'Demo'
        expect(page).to have_content 'Catch!'
        expect(page).to have_content user.name
      end
    end
  end
end
