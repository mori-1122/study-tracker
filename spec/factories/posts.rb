FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyString" }
    association :user, factory: :user
  end
end
