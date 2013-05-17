# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    send_user_id "MyString"
    target_user_id "MyString"
    content "MyString"
    received "MyString"
    readed "MyString"
  end
end
