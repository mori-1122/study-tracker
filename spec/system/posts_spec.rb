require 'rails_helper'

RSpec.describe 'Post', type: :system, skip: 'Docker + Selenium を使わない方針のため system spec は無効化' do
  before do
    @user = create(:user)
  end

  let(:title) { "テストタイトル" }
  let(:content) { "テスト本文" }

  describe "ログ投稿機能の検証" do
    subject do
      fill_in 'post_title', with: title
      fill_in_rich_text_area '本文', with: content
      click_button "ログを記録"
    end

    context "ログインしていない場合" do
      before { visit '/posts/new' }

      it "ログインページへリダイレクトする" do
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content("ログインしてください。")
      end
    end

    context "ログインしている場合" do
      before do
        sign_in @user
        visit '/posts/new'
      end

      it "ログインページへリダイレクトしない" do
        expect(current_path).not_to eq('/users/sign_in')
      end

      context "パラメータが正常な場合" do
        it '投稿内容を作成できる' do
          expect { subject }.to change(Post, :count).by(1)
          expect(current_path).to eq('/')
          expect(page).to have_content("投稿しました")
        end
      end

      context "パラメータが異常な場合" do
        let(:title) { nil }

        it "投稿内容を作成できない" do
          expect { subject }.not_to change(Post, :count)
          expect(page).to have_content("投稿に失敗しました")
        end

        it "入力していた内容は維持される" do
          subject
          expect(page).to have_content(content)
        end
      end
    end
  end
end
