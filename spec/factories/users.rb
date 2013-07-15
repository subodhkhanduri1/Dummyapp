require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.name }
    f.username { Faker::Name.first_name.downcase }
    f.password "password"
  end
end