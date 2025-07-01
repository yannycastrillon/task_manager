FactoryBot.define do
  factory :recurring_assignment do
    sequence(:title) { |n| "Recurring Assignment #{n}" }
    sequence(:description) { |n| "Description for recurring assignment #{n}" }
    start_date { Time.zone.today }
    end_date { Time.zone.today + 30.days }
    frequency { "weekly" } # or "daily", "monthly", etc.
    active { true }

    association :team
    association :business

    trait :inactive do
      active { false }
    end

    trait :daily do
      frequency { "daily" }
    end

    trait :weekly do
      frequency { "weekly" }
    end

    trait :monthly do
      frequency { "monthly" }
    end
  end
end
