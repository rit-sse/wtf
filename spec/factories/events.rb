# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "MyString"
    start_date "2012-01-30"
    end_date "2012-01-30"
    price 1.5
  end
end
