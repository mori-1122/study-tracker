require 'rails_helper'

describe User do
  let(:nickname) { '田中太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '12345678' }
  let(:user) { User.new(nickname: nickname, email: email, password: password) }

  describe ".first" do
    before do
      create(:user, nickname: nickname, email: email, password: password,  password_confirmation: password)
    end

    subject { described_class.first }

    it "事前に作成した通りのUserを返す" do
      expect(subject.nickname).to eq("田中太郎")
      expect(subject.email).to eq("test@example.com")
    end
  end

  describe 'validation' do
    describe 'nickname属性' do
      describe '文字数制限の検証' do
        context "nicknameが20文字以下の場合" do
          let(:nickname) { "あいうえおかきくけこさしすせそたちつてと" }

          it 'Userオブジェクトは有効である' do
            expect(user).to be_valid
          end
        end

        context "nicknameが20文字を超える場合" do
          let(:nickname) { "あいうえおかきくけこさしすせそたちつてとな" }

          it "Userオブジェクトは無効である" do
            user.valid?
            expect(user.errors[:nickname]).to be_present
          end
        end
      end

      describe "存在性の検証" do
        context "nicknameが空欄の場合" do
          let(:nickname) { '' }

          it "Userオブジェクトは無効である" do
            user.valid?
            expect(user.errors[:nickname]).to be_present
          end
        end
      end
    end
  end
end
