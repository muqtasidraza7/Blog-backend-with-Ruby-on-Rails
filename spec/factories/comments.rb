FactoryBot.define do
  factory :comment do
    commenter { "Ali" }
    body { "This is the comment for the article" }
    association :article
  end
end
