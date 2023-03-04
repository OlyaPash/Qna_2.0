require 'rails_helper'

feature 'User can sign up', %{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  describe 'Guest' do
    scenario 'tries to sign up with correct params' do
     visit new_user_registration_path

     fill_in 'Email', with: 'user@example.com'
     fill_in 'Password', with: '123456789'
     fill_in 'Password confirmation', with: '123456789'
     click_on 'Sign up'

     expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with incorrect params' do
      visit new_user_registration_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: '123456789'
      fill_in 'Password confirmation', with: '1234567'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
