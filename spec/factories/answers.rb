FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }
    user

    trait :invalid do
      body { nil }
    end
  end
end
