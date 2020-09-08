# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Posts", type: :request do
  describe "GET /v1/posts#index" do
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
      expect(json["posts"].length).to eq(3)
    end
    it "id降順にレスポンスが返ってくる" do
      get v1_posts_url
      json = JSON.parse(response.body)
      first_id = json["posts"][0]["id"]
      expect(json["posts"][1]["id"]).to eq(first_id - 1)
      expect(json["posts"][2]["id"]).to eq(first_id - 2)
    end
  end

  describe "GET /v1/posts#show" do
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
      expect(json["post"]["subject"]).to eq("showテスト")
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      get v1_post_url({ id: post.id + 1 })
      expect(response.status).to eq 404
    end
  end

  describe "POST /v1/posts#create" do
    let(:new_post) do
      attributes_for(:post, subject: "create_subjectテスト", body: "create_bodyテスト")
    end
    it "正常レスポンスコードが返ってくる" do
      post v1_posts_url, params: new_post
      expect(response.status).to eq 200
    end
    it "1件増えて返ってくる" do
      expect do
        post v1_posts_url, params: new_post
      end.to change { Post.count }.by(1)
    end
    it "subject, bodyが正しく返ってくる" do
      post v1_posts_url, params: new_post
      json = JSON.parse(response.body)
      expect(json["post"]["subject"]).to eq("create_subjectテスト")
      expect(json["post"]["body"]).to eq("create_bodyテスト")
    end
    it "不正パラメータの時にerrorsが返ってくる" do
      post v1_posts_url, params: {}
      json = JSON.parse(response.body)
      expect(json.key?("errors")).to be true
    end
  end

  describe "PUT /v1/posts#update" do
    let(:update_param) do
      post = create(:post)
      update_param = attributes_for(:post, subject: "update_subjectテスト", body: "update_bodyテスト")
      update_param[:id] = post.id
      update_param
    end
    it "正常レスポンスコードが返ってくる" do
      put v1_post_url({ id: update_param[:id] }), params: update_param
      expect(response.status).to eq 200
    end
    it "subject, bodyが正しく返ってくる" do
      put v1_post_url({ id: update_param[:id] }), params: update_param
      json = JSON.parse(response.body)
      expect(json["post"]["subject"]).to eq("update_subjectテスト")
      expect(json["post"]["body"]).to eq("update_bodyテスト")
    end
    it "不正パラメータの時にerrorsが返ってくる" do
      put v1_post_url({ id: update_param[:id] }), params: { subject: "" }
      json = JSON.parse(response.body)
      expect(json.key?("errors")).to be true
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      put v1_post_url({ id: update_param[:id] + 1 }), params: update_param
      expect(response.status).to eq 404
    end
  end

  describe "DELETE /v1/posts#destroy" do
    let(:delete_post) do
      create(:post)
    end
    it "正常レスポンスコードが返ってくる" do
      delete v1_post_url({ id: delete_post.id })
      expect(response.status).to eq 200
    end
    it "1件減って返ってくる" do
      delete_post
      expect do
        delete v1_post_url({ id: delete_post.id })
      end.to change { Post.count }.by(-1)
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      delete v1_post_url({ id: delete_post.id + 1 })
      expect(response.status).to eq 404
    end
  end
end
