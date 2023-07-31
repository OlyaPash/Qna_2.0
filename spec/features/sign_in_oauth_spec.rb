require 'rails_helper'

feature 'Authorization from providers', %{
  In order to have access to app
  As a user
  I'd like to be able to sign in with OAuth
} do

  background { visit new_user_session_path }

  scenario 'Sign in with Vkontakte' do
    OmniAuth.config.add_mock(:vkontakte, { uid: '123456' })
      
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Enter your email'

    fill_in 'Email', with: 'test@gmail.com'
    click_on 'Submit'
    open_email('test@gmail.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
  end

  scenario 'Sign in with GitHub' do
    OmniAuth.config.add_mock(:github, { uid: '123456' })

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Enter your email'

    fill_in 'Email', with: 'github@gmail.com'
    click_on 'Submit'
    open_email('github@gmail.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from github account.'
  end
end
