FactoryBot.define do
    factory :team do
      sequence(:name) { |n| "テストチーム#{n}" }

      transient do
        sequence_id { 1 }
      end

      league_id { ((sequence_id - 1) % 5) + 1 }
    end
end
