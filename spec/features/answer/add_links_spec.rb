require 'rails_helper'

feature 'User can add links to answer', %{
  In order to provide additional info my answer
  As an answers author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  describe 'User' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds correct links', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Text answer'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Create answer'
      end

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'tries adds invalid links', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Text answer'

        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'chtoto'

        click_on 'Create answer'
      end

      within '.answer-errors' do
        expect(page).to have_content 'Links url are not valid'
      end
    end
  end
end
