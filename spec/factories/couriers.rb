FactoryBot.define do
  factory :courier do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
