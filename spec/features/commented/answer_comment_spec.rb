require 'rails_helper'

feature 'User can add comments to answer', %{
  In order to leave additional information about answers
  As an authenticated
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'can add comment for answer' do
      sign_in(user)
      visit question_path(question)
 
      within '.answers' do
        fill_in 'answer-comment-body', with: 'New answer comment'
        click_on 'Add comment'

        expect(page).to have_content 'New answer comment'
      end
    end
  end

  context 'mulitple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'answer-comment-body', with: 'New answer comment'
          click_on 'Add comment'
  
          expect(page).to have_content 'New answer comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New answer comment'
      end
    end
  end
end
