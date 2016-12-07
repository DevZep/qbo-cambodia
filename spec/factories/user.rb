# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email     'admin@example.com'
    password  'Rotati@90'
    password_confirmation 'Rotati@90'
  end
end
