# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  subject { described_class }

  permissions :index?, :show? do
    it "未ログインの時に許可" do
      expect(subject).to permit(nil, post)
    end
  end

  permissions :create? do
    it "未ログインの時に不許可" do
      expect(subject).not_to permit(nil, post)
    end
    it "ログインしている時に許可" do
      expect(subject).to permit(user, post)
    end
  end

  permissions :update?, :destroy? do
    it "未ログインの時に不許可" do
      expect(subject).not_to permit(nil, post)
    end
    it "ログインしているが別ユーザーの時に不許可" do
      expect(subject).not_to permit(user, post)
    end
    it "ログインしていて同一ユーザーの時に許可" do
      post.user = user
      expect(subject).to permit(user, post)
    end
  end
end
