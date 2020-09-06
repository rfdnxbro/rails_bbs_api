# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    subject { "MyString" }
    body { "MyText" }
  end
end
