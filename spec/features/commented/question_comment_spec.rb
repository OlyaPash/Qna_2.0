require 'rails_helper'



feature 'User can add comments to question', %{
  In order to leave additional information about questions
  As an authenticated
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'can add comment for question' do
      sign_in(user)
      visit question_path(question)
 
      within '.question' do
        fill_in 'question-comment-body', with: 'New question comment'
        click_on 'Add comment'

        expect(page).to have_content 'New question comment'
      end
    end
  end

  context 'mulitple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
    
      Capybara.using_session('guest') do
        visit question_path(question)
      end
    
      Capybara.using_session('user') do
        within '.question' do
          fill_in 'question-comment-body', with: 'New question comment'
          click_on 'Add comment'
  
          expect(page).to have_content 'New question comment'
        end
      end
    
      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'New question comment'
        end
      end
    end
  end
end
