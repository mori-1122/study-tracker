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

  context "異常系" do
    it "emailの形式が不正な場合、ユーザーを作成しない" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: "invalid-email"
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Email is invalid")
    end

    it "emailが既に存在する場合、ユーザーを作成しない" do
      create(:user, email: email)

      visit '/users/sign_up'

      fill_in "user_nickname", with: nickname
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(1)
      expect(page).to have_content("Email has already been taken")
    end

    it "全項目が空の場合、ユーザーを作成しない" do
      visit '/users/sign_up'

      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Nickname can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

    it "nicknameが空白文字のみの場合、ユーザーを作成しない" do
      visit '/users/sign_up'

      fill_in "user_nickname", with: "   "
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button "登録する"

      expect(User.count).to eq(0)
      expect(page).to have_content("Nickname can't be blank")
    end
  end

  describe "ログイン機能の検証" do
    before do
      create(
        :user,
        nickname: nickname,
        email: email,
        password: password,
        password_confirmation: password
      )
    end

    context "正常系" do
      it "ログインに成功し、トップページに遷移される" do
        visit '/users/sign_in'

        fill_in "user_email", with: email
        fill_in "user_password", with: password
        click_button "ログイン"

        expect(current_path).to eq('/')
      end
    end

    context "異常系" do
      it "ログインに失敗し、ページを遷移しない" do
        visit '/users/sign_in'

        fill_in "user_email", with: email
        fill_in "user_password", with: "NGpassword"
        click_button "ログイン"

        expect(current_path).to eq('/users/sign_in')
      end
    end
  end
end
