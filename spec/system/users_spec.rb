require 'rails_helper'

RSpec.describe "Users", type: :system do
  before { driven_by :rack_test }

  let(:email) { 'test@example.com' }
  let(:nickname) { "田中太郎" }
  let(:password) { "password" }
  let(:password_confirmation) { password }

  context "正常系" do
    it "ユーザーを作成できる" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(1)
      expect(current_path).to eq('/')
    end
  end

  context "nicknameが空の場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: ""
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Nickname can't be blank")
    end
  end

  context "nicknameが20文字を超える場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: "あ" * 21
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Nickname is too long")
    end
  end

  context "emailが空の場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: ""
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Email can't be blank")
    end
  end

  context "passwordが6文字未満の場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: email
      fill_in "user_password", with: "a" * 5
      fill_in "user_password_confirmation", with: "a" * 5
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content(
        "Password is too short (minimum is 6 characters)"
      )
    end
  end

  context "passwordが128文字を超える場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: email
      fill_in "user_password", with: "a" * 129
      fill_in "user_password_confirmation", with: "a" * 129
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content(
        "Password is too long (maximum is 128 characters)"
      )
    end
  end

  context "passwordとpassword_confirmationが一致しない場合" do
    it "ユーザーを作成せず、エラーメッセージを表示する" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: "#{password}hoge"
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content(
        "Password confirmation doesn't match Password"
      )
    end
  end
end
