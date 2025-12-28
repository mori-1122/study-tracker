require 'rails_helper'

RSpec.describe "Homes", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'トップページの検証' do
    it '文字が表示される' do
      visit '/'
      expect(page).to have_content 'view'
    end
  end

  describe "ナビゲーションバーの検証" do
    context "ログインしていない状態" do
      it "ユーザー登録リンクが表示される" do
        visit root_path
        expect(page).to have_link("ユーザー登録", href: '/users/sign_up')
      end

      it "ログインボタンが表示される" do
        visit root_path
        expect(page).to have_link('ログイン', href: '/users/sign_in')
      end

      it "ログアウトボタンが表示されない" do
        expect(page).not_to have_button("ログアウト")
      end
    end

    context "ログインしている場合" do
      it "ユーザー登録ボタンとログインボタンは表示されない" do
        sign_in create(:user)
        visit root_path
        expect(page).not_to have_button("ユーザー登録", href: '/users/sign_up')
        expect(page).not_to have_button("ログイン", href: '/users/sign_in')
      end

      it "ログアウトボタンを表示する" do
        sign_in create(:user)
        visit root_path

        expect(page).to have_button("ログアウト")
      end

      it "ログアウトできる" do
        sign_in create(:user)
        visit root_path

        click_button "ログアウト"

        expect(page).to have_button("ユーザー登録", href: '/users/sign_up')
        expect(page).to have_button("ログイン", href: '/users/sign_in')
        expect(page).not_to have_content("ログアウト")
      end
    end
  end
end
