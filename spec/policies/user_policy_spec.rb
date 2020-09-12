# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  subject { described_class }

  permissions :index?, :create?, :destroy? do
    it "未ログインの時に不許可" do
      expect(subject).not_to permit(nil, user)
    end
    it "adminユーザー以外でログインしている時に不許可" do
      expect(subject).not_to permit(user, user)
    end
    it "adminユーザーでログインしている時に許可" do
      expect(subject).to permit(admin_user, user)
    end
  end

  permissions :show?, :update? do
    it "未ログインの時に不許可" do
      expect(subject).not_to permit(nil, user)
    end
    it "ログインしているが別ユーザーの時に不許可" do
      expect(subject).not_to permit(user, another_user)
    end
    it "adminユーザーでログインしている時に許可" do
      expect(subject).to permit(admin_user, user)
    end
    it "ログインしていて同一ユーザーの時に許可" do
      expect(subject).to permit(user, user)
    end
  end
end
