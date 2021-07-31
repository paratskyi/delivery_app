FactoryBot.define do
  factory :package do
    association :courier
    tracking_number { "MyString" }
    delivery_status { false }
  end
end
