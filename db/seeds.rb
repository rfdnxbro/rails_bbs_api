# frozen_string_literal: true

seed_models = %i[post]
seed_models.each do |model|
  require "./db/seeds/#{model}_seeds"
end
