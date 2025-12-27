require 'rails_helper' # rails_helperを読み込み

RSpec.describe "Home", type: :request do # テスト対象モジュールと、テストの種類
  describe "GET /" do # テストに関すつ説明
    it "トップページを開くと「成功」の返事が返る" do # 期待する結果
      get "/" # どういうパスにgetリクエストを投げる
      expect(response).to have_http_status(200) # 結果
    end
  end
end
