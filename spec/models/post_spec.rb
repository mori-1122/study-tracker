require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:title) { "テストタイトル" }
  let(:content) { "テスト本文" }

  subject do
    described_class.new(
      title: title,
      content: content,
      user: user
    )
  end

  describe "バリデーションの検証" do
    it "有効である" do
      expect(subject).to be_valid
    end

    it "titleが空の場合は無効である" do
      subject.title = nil
      subject.valid?
      expect(subject.errors[:title]).to include("が入力されていません。")
    end

    it "titleが100文字を超える場合は無効である" do
      subject.title = "あ" * 101
      expect(subject).not_to be_valid
    end

    it "contentが空の場合は無効である" do
      subject.content = ""
      subject.valid?
      expect(subject.errors[:content]).to include("が入力されていません。")
    end

    it "contentが1000文字を超える場合は無効である" do
      subject.content = "あ" * 1001
      expect(subject).not_to be_valid
    end
  end

  describe "Postが持つ情報の検証" do
    it "Postの属性値を正しく保持している" do
      post = create(:post, title: title, content: content, user: user)

      expect(post.title).to eq("テストタイトル")
      expect(post.content.body.to_plain_text).to eq("テスト本文")
      expect(post.user_id).to eq(user.id)
    end
  end
end
