# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :block do
    content "MyString"
    extra_attributes "MyString"
  end
end
