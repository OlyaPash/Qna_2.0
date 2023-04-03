require 'rails_helper'

feature 'User can vote up/down for question, answer', %{
  In order to determine the degree of usefulness of questions and answers
  As an authenticated user
  I would like to be able to vote
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user no author', js: true do
    background { sign_in(no_author) }

    scenario 'can vote for favorite question' do
      visit questions_path

      click_on 'Like'
      expect(page).to have_content 1
    end

    scenario 'can cancel vote for question' do
      visit questions_path

      click_on 'Like'
      expect(page).to have_content 1

      click_on 'Cancel'
      expect(page).to have_content 0
    end

    scenario 'can tap dislike for question' do
      visit questions_path

      click_on 'Dislike'
      expect(page).to have_content -1
    end

    scenario 'can vote for favorite answer' do
      visit question_path(question)

      click_on 'Like'
      expect(page).to have_content 1
    end

    scenario 'can tap dislike for answer' do
      visit question_path(question)

      click_on 'Dislike'
      expect(page).to have_content -1
    end

    scenario 'can cancel vote for answer' do
      visit question_path(question)

      click_on 'Dislike'
      expect(page).to have_content -1

      click_on 'Cancel'
      expect(page).to have_content 0
    end
  end

  describe 'User is author', js: true do
    background { sign_in(user) }

    scenario 'tries vote for question' do
      visit questions_path

      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
      expect(page).to_not have_link 'Cancel'
    end

    scenario 'tries vote for answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
      expect(page).to_not have_link 'Cancel'
    end
  end
end
