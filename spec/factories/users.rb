# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    #sequence(:name) {|n| "user#{n}" }
    #user.password               "password"
    #user.password_confirmation  "password"
    sequence(:password) {|n| "password#{n}" }
    sequence(:password_confirmation) {|n| "password#{n}" }

  end

  factory :confirmed_user, :parent => :user do
    after(:create) { |user| user.confirm! }
  end
end
