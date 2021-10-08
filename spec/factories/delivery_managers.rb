FactoryBot.define do
  factory :delivery_manager do
    enabled { true }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
