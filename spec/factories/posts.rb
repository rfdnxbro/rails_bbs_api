# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    subject { "MyString" }
    body { "MyText" }

    after(:build) do |obj|
      obj.user = build(:user) if obj.user.nil?
    end
  end
end
