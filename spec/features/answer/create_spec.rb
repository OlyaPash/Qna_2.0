require 'rails_helper'

feature 'User can write the answer on the question page', %{
  To help with a question
  As an authenticated user
  I would like to be able to write an answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
      click_on question.title
    end

    scenario 'write an answer' do
      within '.new-answer' do
        fill_in 'Body', with: 'Text answer'
        click_on 'Create answer'
      end

      within '.answers' do
        expect(page).to have_content 'Text answer'
      end
    end

    scenario 'write an answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'write answer with attached file' do
      within '.new-answer' do
        fill_in 'Body', with: 'Text answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
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
        within '.new-answer' do
          fill_in 'Body', with: 'Text answer'
          click_on 'Create answer'
        end
        
        within '.answers' do
          expect(page).to have_content 'Text answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Text answer'
      end
    end
  end

  scenario 'An unauthenticated user cannot create a answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Text answer'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
