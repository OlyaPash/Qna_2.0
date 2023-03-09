require 'rails_helper'

feature 'User can choose the best answer on the question page', %{
  To help with a question
  As an authenticated user
  I would like to be able to choose the best answer
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'Authenticated user' do
    scenario 'author select the best answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Make answer best'

      within '.answers' do
        expect(page).to have_content 'Best answer'
      end
    end

    scenario 'no author tries select the best answer', js: true do
      sign_in(no_author)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Make answer best'
      end
    end
  end

  scenario 'Unauthenticated can not select the best answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Make answer best'
    end
  end
end