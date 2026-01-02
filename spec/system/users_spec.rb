require 'rails_helper'

RSpec.describe "Users", type: :system do
  before { driven_by :rack_test }

  let(:email) { 'test@example.com' }
  let(:nickname) { "田中太郎" }
  let(:password) { "password" }
  let(:password_confirmation) { password }

  describe "ユーザー登録" do
    before do
      visit '/users/sign_up'
    end

    context "nicknameが空の場合" do
      it "ユーザーを作成せず、エラーメッセージを表示する" do
        fill_in "user_nickname", with: ""
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        fill_in "user_password_confirmation", with: password_confirmation
        click_button "登録する"

        expect(User.count).to eq(0)
        expect(page).to have_content("ニックネーム が入力されていません。")
      end
    end

    context "nicknameが20文字を超える場合" do
      it "ユーザーを作成せず、エラーメッセージを表示する" do
        fill_in "user_nickname", with: "あ" * 21
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        fill_in "user_password_confirmation", with: password_confirmation
        click_button "登録する"

        expect(User.count).to eq(0)
        expect(page).to have_content("ニックネーム は20文字以下に設定して下さい。")
      end
    end

    context "passwordが128文字を超える場合" do
      it "ユーザーを作成せず、エラーメッセージを表示する" do
        fill_in "user_nickname", with: nickname
        fill_in "user_email", with: email
        fill_in "user_password", with: "a" * 129
        fill_in "user_password_confirmation", with: "a" * 129
        click_button "登録する"

        expect(User.count).to eq(0)
        expect(page).to have_content("パスワード は128文字以下に設定して下さい。")
      end
    end

    context "passwordとpassword_confirmationが一致しない場合" do
      it "ユーザーを作成せず、エラーメッセージを表示する" do
        fill_in "user_nickname", with: nickname
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        fill_in "user_password_confirmation", with: "#{password}hoge"
        click_button "登録する"

        expect(User.count).to eq(0)
        expect(page).to have_content("確認用パスワード が一致していません。")
      end

      it "nicknameが空白文字のみの場合、ユーザーを作成しない" do
        fill_in "user_nickname", with: "   "
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        fill_in "user_password_confirmation", with: password_confirmation
        click_button "登録する"

        expect(User.count).to eq(0)
        expect(page).to have_content("ニックネーム が入力されていません。")
      end
    end
  end
end
