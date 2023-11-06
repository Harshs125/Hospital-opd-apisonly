require 'faker'
FactoryBot.define do
    factory :doctor do
        name {Faker::Name.name}
        email {Faker::Internet.email}
        mobile {Faker::PhoneNumber.phone_number}
        specialization {Faker::Lorem.word}
        timing_from {"09:00"}
        timing_to {"17:00"}
        created_at  {Time.now}
        updated_at  {Time.now}
    end
end