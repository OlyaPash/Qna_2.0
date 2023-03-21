require 'rails_helper'

feature 'User can remove links to question', %{
  To clarify my question
  As a question author
  I would like to be able to remove links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  scenario 'User can delete links', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    within '.question' do
      click_on 'Delete link'

      expect(page).to_not have_link 'My gist'
    end
  end
end
