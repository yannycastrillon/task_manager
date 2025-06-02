FactoryBot.define do
  factory :task do
    name { "MyString" }
    description { "MyText" }
    priority { "MyString" }
    status { "MyString" }
    due_date { "2025-05-30" }
  end
end
