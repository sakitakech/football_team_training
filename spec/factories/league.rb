FactoryBot.define do
    factory :league do
      sequence(:league) { |n| "test#{n}" }
      password { "password" }
      password_confirmation { "password" }
    end
  end