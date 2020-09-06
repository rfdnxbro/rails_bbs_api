# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post, type: :model do
  describe "subject" do
    context "blankの時に" do
      it "invalidになる" do
        post = Post.new(subject: "", body: "fuga")
        expect(post).not_to be_valid
      end
    end
    context "maxlengthにより" do
      context "30文字の場合に" do
        it "validになる" do
          post = Post.new(subject: "あ" * 30, body: "fuga")
          expect(post).to be_valid
        end
      end
      context "31文字の場合に" do
        it "invalidになる" do
          post = Post.new(subject: "あ" * 31, body: "fuga")
          expect(post).not_to be_valid
        end
      end
    end
  end
end
