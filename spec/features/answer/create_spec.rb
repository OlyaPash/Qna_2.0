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
      fill_in 'Body', with: 'Text answer'
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_content 'Text answer'
      end
    end

    scenario 'write an answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'write answer with attached file' do
      fill_in 'Body', with: 'Text answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'An unauthenticated user cannot create a answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Text answer'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
