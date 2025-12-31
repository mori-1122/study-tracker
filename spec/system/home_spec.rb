require 'rails_helper'

RSpec.describe "Homes", type: :system do
  before { driven_by(:rack_test) }

  describe "ナビゲーションバーの検証" do
    context "ログインしていない状態" do
      it "ユーザー登録リンクが表示される" do
        visit root_path
        expect(page).to have_link(href: '/users/sign_up')
      end

      it "ログインリンクが表示される" do
        visit root_path
        expect(page).to have_link(href: '/users/sign_in')
      end

      it "ログアウトボタンが表示されない" do
        visit root_path
        expect(page).not_to have_button("ログアウト")
      end
    end

    context "ログインしている場合" do
      it "ユーザー登録とログインは表示されない" do
        sign_in create(:user)
        visit root_path

        expect(page).not_to have_link(href: '/users/sign_up')
        expect(page).not_to have_link(href: '/users/sign_in')
      end

      it "ログアウトボタンが表示される" do
        sign_in create(:user)
        visit root_path

        expect(page).to have_button("ログアウト")
        expect(page).to have_selector("form[action='/users/sign_out']")
      end

      it "ログアウトできる" do
        sign_in create(:user)
        visit root_path

        click_button "ログアウト"

        expect(page).to have_link(href: '/users/sign_in')
        expect(page).to have_link(href: '/users/sign_up')
        expect(page).not_to have_button("ログアウト")
      end
    end
  end
end
