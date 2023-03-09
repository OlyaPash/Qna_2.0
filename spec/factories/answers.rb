FactoryBot.define do
  factory :answer do
    body { "MyTextAnswer" }
    question { nil }
    user

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
