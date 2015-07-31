FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@caiena.net" }
    password Faker::Internet.password(8)
  end

  factory :post do
    title Faker::Lorem.sentence(1)
    content Faker::Lorem.characters(140)
    user
  end
end
