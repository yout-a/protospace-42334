# spec/system/prototypes_spec.rb
require 'rails_helper'

RSpec.describe 'プロトタイプ投稿機能', type: :system do
  before { driven_by(:rack_test) }

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
      it '投稿できてトップページに遷移し、投稿内容が表示されること' do
        fill_in 'プロトタイプ名', with: 'My Prototype'
        fill_in 'キャッチコピー',   with: 'This is a catch copy'
        fill_in 'コンセプト',       with: 'Prototype concept'
        attach_file '画像', Rails.root.join('spec/fixtures/files/test_image.png')
        click_button '投稿'

        # 投稿後はトップへリダイレクト
        expect(current_path).to eq root_path
        # 投稿情報が表示される
        within('.prototypes-list') do
          expect(page).to have_selector "img[src*='test_image.png']"
          expect(page).to have_content 'My Prototype'
          expect(page).to have_content 'This is a catch copy'
          expect(page).to have_content user.name
        end
      end
    end

    context '必須情報が未入力の場合' do
      it '投稿できずに同じページに留まり、入力済みの情報（画像以外）は消えないこと' do
        fill_in 'プロトタイプ名', with: 'Incomplete'
        # キャッチコピーとコンセプトは未入力
        attach_file '画像', Rails.root.join('spec/fixtures/files/test_image.png')
        click_button '投稿'

        # エラー表示と同ページ
        expect(page).to have_current_path prototypes_path
        expect(page).to have_content 'キャッチコピーを入力してください'

        # 入力済みフィールドは保持
        expect(find_field('プロトタイプ名').value).to eq 'Incomplete'
        # ファイル選択はクリアされる（ActiveStorage仕様）
        expect(page).not_to have_selector "img[src*='test_image.png']"
      end
    end
  end

  describe 'トップページの表示内容' do
    let!(:prototype) { create(:prototype, user: user, name: 'Demo', catch_copy: 'Catch!', concept: 'Concept', images: [fixture_file_upload('files/test_image.png', 'image/png')]) }

    it '投稿情報一覧にプロトタイプごとに画像・名称・キャッチコピー・投稿者名が表示され、リンク切れでないこと' do
      visit root_path
      within("#prototype_#{prototype.id}") do
        expect(page).to have_selector "img[src*='test_image.png']"
        expect(page).to have_content 'Demo'
        expect(page).to have_content 'Catch!'
        expect(page).to have_content user.name
      end
    end
  end
end
