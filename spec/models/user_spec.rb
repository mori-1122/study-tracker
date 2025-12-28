require 'rails_helper'

 RSpec.describe User, type: :model do
  let(:nickname) { '田中太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '12345678' }
  let(:user) { User.new(nickname: nickname, email: email, password: password, password_confirmation: password) }

  describe "create user" do
    it "作成したUserの属性が正しい" do
      create(:user, nickname: nickname, email: email)
      expect(User.first.nickname).to eq("田中太郎")
      expect(User.first.email).to eq("test@example.com")
    end
  end

  describe "validation" do
    describe "nickname" do
      context "20文字以下の場合" do
        let(:nickname) { "あいうえおかきくけこさしすせそたちつてと" }

        it '有効である' do
          expect(user.valid?).to be true
        end
      end

      context "20文字を超える場合" do
        let(:nickname) { "あいうえおかきくけこさしすせそたちつてとな" }
        it '無効である' do
          expect(user.valid?).to be false
          expect(user.errors[:nickname]).to include('is too long (maximum is 20 characters)')
        end
      end

      context '空欄の場合' do
        let(:nickname) { '' }
        it '無効である' do
          expect(user.valid?).to be false
          expect(user.errors[:nickname]).to include("can't be blank")
        end
      end
    end
  end
end
