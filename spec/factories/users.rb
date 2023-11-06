# Assuming you have a User model defined in app/models/user.rb

# spec/factories/users.rb

FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      encrypted_password {"password@123"}
      reset_password_token { Faker::Internet.uuid }
      reset_password_sent_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
      remember_created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
      created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
      updated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
      jti { Faker::Internet.uuid }
      username { Faker::Internet.user_name }
      role { %w[admin user].sample }
  
      # Optional: You can define traits if you want to generate users with specific attributes
      trait :admin do
        role { 'admin' }
      end
  
      trait :user do
        role { 'user' }
      end
    end
  end
  