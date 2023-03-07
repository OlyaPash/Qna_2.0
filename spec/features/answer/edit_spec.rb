require 'rails_helper'

feature 'User can edit his answer', %{
  In order to correct mistakes
  As an author of answer
  I would like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edited his answer with errors', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      
      within '.answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save'
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer",js: true do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end
end
