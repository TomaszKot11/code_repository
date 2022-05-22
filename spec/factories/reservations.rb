# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    ticket
    user_uid { SecureRandom.uuid }
    count { Faker::Number.within(range: 1..10) }
  end
end
