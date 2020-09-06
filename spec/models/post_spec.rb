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
  end
end
