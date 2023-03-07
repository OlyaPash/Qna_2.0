require 'rails_helper'

feature 'User can edit their questions', %{
  In order to correct mistakes
  As an author of question
  I would like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    scenario 'edits their questions', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Body', with: 'edited'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edited his question with errors', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      within '.question-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(user_not_author)
      visit question_path(question)
      
      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end
  end

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question' 
  end
end
