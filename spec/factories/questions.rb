FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :created_at_yesterday do
      created_at { Date.yesterday }
    end
  end
end
