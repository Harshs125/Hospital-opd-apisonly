require 'faker'
FactoryBot.define do
    factory :patient do
        name {Faker::Name.name}
        email {Faker::Internet.email}
        mobile {Faker::PhoneNumber.phone_number}
    end
end