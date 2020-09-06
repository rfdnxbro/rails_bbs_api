# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Posts", type: :request do
  describe "GET #index" do
    before do
      create_list(:post, 3)
    end
    it "正常レスポンスコードが返ってくる" do
      get v1_posts_url
      expect(response.status).to eq 200
    end
    it "件数が正しく返ってくる" do
      get v1_posts_url
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(3)
    end
    it "id降順にレスポンスが返ってくる" do
      get v1_posts_url
      json = JSON.parse(response.body)
      first_id = json["data"][0]["id"]
      expect(json["data"][1]["id"]).to eq(first_id - 1)
      expect(json["data"][2]["id"]).to eq(first_id - 2)
    end
  end

  describe "GET #show" do
    let(:post) do
      create(:post, subject: "showテスト")
    end
    it "正常レスポンスコードが返ってくる" do
      get v1_post_url({ id: post.id })
      expect(response.status).to eq 200
    end
    it "subjectが正しく返ってくる" do
      get v1_post_url({ id: post.id })
      json = JSON.parse(response.body)
      expect(json["data"]["subject"]).to eq("showテスト")
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      get v1_post_url({ id: post.id + 1 })
      expect(response.status).to eq 404
    end
  end
end
