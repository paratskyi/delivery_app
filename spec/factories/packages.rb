FactoryBot.define do
  factory :package do
    association :courier
    sequence(:tracking_number) { |n| "MyString #{n}" }
  end
end
