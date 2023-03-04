require 'rails_helper'

feature 'User can sign out', %{
  To end a session
  As an authenticated user
  I would like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registrered user tries to sign out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
