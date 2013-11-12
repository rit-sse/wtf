# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    dce "MyString"
    first_name "MyString"
    last_name "MyString"
    reason "MyText"
    date "2013-11-09"
  end
end
