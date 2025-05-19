FactoryBot.define do
    factory :training do
      association :user  # ユーザーと紐づけ（必須）

      datetime { Time.current }
      part     { "上半身" }
      content  { "ベンチプレス、懸垂" }
      memo     { "疲労感あり。重量伸び悩み。" }
      body_weight { |n| "#{n}0" }
      body_fat    { |n| "#{n}" }
    end
  end
