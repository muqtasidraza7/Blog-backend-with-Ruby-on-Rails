FactoryBot.define do
  factory :article do
    association :user
    title { "Learning Rails" }
    body { "A body long enough to pass validation" }
  end
end
