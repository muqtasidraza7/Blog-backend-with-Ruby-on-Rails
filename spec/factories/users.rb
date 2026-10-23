FactoryBot.define do
  factory :user do
    sequence(:email_address) { |number| "learner#{number}@example.com" }
    password { "Development-test-password-123!" }
    password_confirmation { password }
  end
end
