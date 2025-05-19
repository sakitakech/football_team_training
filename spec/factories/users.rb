FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password" }
      password_confirmation { "password" }
      sequence(:first_name) { |n| "名#{n}" }
      sequence(:last_name)  { |n| "姓#{n}" }

      position_id { 1 } # WRなど、1〜13までseedで存在
      team_id     { nil } # 必要に応じて trait で設定

      trait :team1 do
        team_id { 1 }
      end

      trait :team2 do
        team_id { 2 }
      end
    end
  end
