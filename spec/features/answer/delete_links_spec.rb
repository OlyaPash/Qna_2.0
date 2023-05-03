require 'rails_helper'

feature 'User can remove links to answer', %{
  To clarify my answer
  As a answer author
  I would like to be able to remove links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  scenario 'User can delete links', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Text answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create answer'
    end

    within '.answers' do
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link 'My gist'
    end
  end
end
