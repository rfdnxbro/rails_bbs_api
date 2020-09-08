# frozen_string_literal: true

unless Post.exists?
  20.times do
    Post.create!(subject: Faker::Lorem.word, body: Faker::Lorem.paragraph)
  end
end
