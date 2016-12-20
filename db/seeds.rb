# frozen_string_literal: true
FactoryGirl.create(:user, email: 'darren@rotati.com', password: 'z2uxb5', password_confirmation: 'z2uxb5')      if User.find_by(email: 'darren@rotati.com').nil?
FactoryGirl.create(:user, email: 'vibol@rotati.com', password: 'z2uxb6', password_confirmation: 'z2uxb6')       if User.find_by(email: 'vibol@rotati.com').nil?
FactoryGirl.create(:user, email: 'ainglorchhan@gmail.com', password: 'z2uxb7', password_confirmation: 'z2uxb7') if User.find_by(email: 'ainglorchhan@gmail.com').nil?
