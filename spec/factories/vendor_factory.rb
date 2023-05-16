FactoryBot.define do
  factory :vendor do
    name { Faker::Commerce.vendor }
    description { Faker::Lorem.sentence }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean(true_ratio: 0.5) }
  end
end