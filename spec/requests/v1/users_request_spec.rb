# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Users", type: :request do
  before do
    @user = create(:user, name: "userテスト")
    @authorized_headers = authorized_user_headers @user
    admin = create(:user, :admin)
    @authorized_admin_headers = authorized_user_headers admin
  end
  describe "GET /v1/users#index" do
    before do
      create_list(:user, 3)
    end
    it "正常レスポンスコードが返ってくる" do
      get v1_users_url, headers: @authorized_admin_headers
      expect(response.status).to eq 200
    end
    it "件数が正しく返ってくる" do
      get v1_users_url, headers: @authorized_admin_headers
      json = JSON.parse(response.body)
      expect(json["users"].length).to eq(3 + 2) # headers用2件を含む
    end
    it "id降順にレスポンスが返ってくる" do
      get v1_users_url, headers: @authorized_admin_headers
      json = JSON.parse(response.body)
      first_id = json["users"][0]["id"]
      expect(json["users"][1]["id"]).to eq(first_id - 1)
      expect(json["users"][2]["id"]).to eq(first_id - 2)
      expect(json["users"][3]["id"]).to eq(first_id - 3)
      expect(json["users"][4]["id"]).to eq(first_id - 4)
    end
  end

  describe "GET /v1/users#show" do
    it "正常レスポンスコードが返ってくる" do
      get v1_user_url({ id: @user.id }), headers: @authorized_headers
      expect(response.status).to eq 200
    end
    it "nameが正しく返ってくる" do
      get v1_user_url({ id: @user.id }), headers: @authorized_headers
      json = JSON.parse(response.body)
      expect(json["user"]["name"]).to eq("userテスト")
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      last_user = User.last
      get v1_user_url({ id: last_user.id + 1 }), headers: @authorized_headers
      expect(response.status).to eq 404
    end
  end

  describe "POST /v1/users#create" do
    let(:new_user) do
      attributes_for(:user, name: "create_nameテスト", email: "email+create_test@example.com", admin: true)
    end
    it "正常レスポンスコードが返ってくる" do
      post v1_users_url, params: new_user, headers: @authorized_admin_headers
      expect(response.status).to eq 200
    end
    it "1件増えて返ってくる" do
      expect do
        post v1_users_url, params: new_user, headers: @authorized_admin_headers
      end.to change { User.count }.by(1)
    end
    it "name, email, adminが正しく返ってくる" do
      post v1_users_url, params: new_user, headers: @authorized_admin_headers
      json = JSON.parse(response.body)
      expect(json["user"]["name"]).to eq("create_nameテスト")
      expect(json["user"]["email"]).to eq("email+create_test@example.com")
      expect(json["user"]["admin"]).to be true
    end
    it "不正パラメータの時にerrorsが返ってくる" do
      post v1_users_url, params: {}, headers: @authorized_admin_headers
      json = JSON.parse(response.body)
      expect(json.key?("errors")).to be true
    end
  end

  describe "PUT /v1/users#update" do
    let(:update_param) do
      update_param = attributes_for(:user, name: "update_nameテスト", email: "email+update_test@example.com", admin: true)
      update_param[:id] = @user.id
      update_param
    end
    it "正常レスポンスコードが返ってくる" do
      put v1_user_url({ id: update_param[:id] }), params: update_param, headers: @authorized_headers
      expect(response.status).to eq 200
    end
    it "name, email, adminが正しく返ってくる" do
      put v1_user_url({ id: update_param[:id] }), params: update_param, headers: @authorized_headers
      json = JSON.parse(response.body)
      expect(json["user"]["name"]).to eq("update_nameテスト")
      expect(json["user"]["email"]).to eq("email+update_test@example.com")
      expect(json["user"]["admin"]).to be false # admin権限は書き換えできると困るのでfalseのまま
    end
    it "不正パラメータの時にerrorsが返ってくる" do
      put v1_user_url({ id: update_param[:id] }), params: { name: "" }, headers: @authorized_headers
      json = JSON.parse(response.body)
      expect(json.key?("errors")).to be true
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      last_user = User.last
      put v1_user_url({ id: last_user.id + 1 }), params: update_param, headers: @authorized_admin_headers
      expect(response.status).to eq 404
    end
  end

  describe "DELETE /v1/users#destroy" do
    it "正常レスポンスコードが返ってくる" do
      delete v1_user_url({ id: @user.id }), headers: @authorized_admin_headers
      expect(response.status).to eq 200
    end
    it "1件減って返ってくる" do
      expect do
        delete v1_user_url({ id: @user.id }), headers: @authorized_admin_headers
      end.to change { User.count }.by(-1)
    end
    it "存在しないidの時に404レスポンスが返ってくる" do
      last_user = User.last
      delete v1_user_url({ id: last_user.id + 1 }), headers: @authorized_admin_headers
      expect(response.status).to eq 404
    end
  end
end
